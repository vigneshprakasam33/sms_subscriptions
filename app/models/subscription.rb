class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :message
  belongs_to :category
  has_many :jobs

  validates_presence_of :duration

  attr_accessor :update_flag, :update_delivery_time_flag, :update_mute_flag

  after_create :subscription_message_fill
  after_update :subscription_message_updated, :if => (:message_id_changed?)
  after_update :delivery_time_updated, :if => (:delivery_time_changed?)
  after_update :mute_updated, :if => (:mute_changed?)
  after_create :enqueue_first_job
  after_destroy :destroy_dj

  #delete the enqueued job
  def destroy_dj
    delete_enqueued_jobs
  end

  def mute_updated
    if self.update_mute_flag.blank? and self.created_at != self.updated_at
      logger.debug "---------mute updated----------------"
      self.update_mute_flag = true
      self.save
      delete_enqueued_jobs
      enqueue_first_job
    end
  end

  def delivery_time_updated
    if self.update_delivery_time_flag.blank? and self.created_at != self.updated_at
      logger.debug "---------delivery time updated----------------"
      self.update_delivery_time_flag = true
      self.save
      delete_enqueued_jobs
      enqueue_first_job
    end
  end

  def subscription_message_fill
    self.update_flag = true
    self.subscription_message = self.message.name
    self.save
  end

  def subscription_message_updated
    if self.update_flag.blank? and self.created_at != self.updated_at
      self.update_flag = true
      self.save
      logger.debug "----Subscription message has been changed----"

      delete_enqueued_jobs

      self.subscription_message = self.message.name
      self.save

      enqueue_first_job
    end
  end

  def send_message(text, number)
    account_sid = 'AC464e95aa436faa83c989a5140d8a0b66'
    auth_token = 'a49866d0a744d8642da934997ce71f78'


    client =Twilio::REST::Client.new $account_sid, $auth_token
    client.account.messages.create(:from => "+441172001588", :body => text, :to => number)
  end


  #convert delivery time to 0 - 23 hrs format
  def delivery_time_hours
    if self.delivery_time.last(2) == "AM"
      (self.delivery_time.split(' ')[0]).to_i
    elsif self.delivery_time.last(2) == "PM"
      #12 pm or later
      (self.delivery_time.split(' ')[0]).to_i + (  (self.delivery_time.split(' ')[0]).to_i  == 12 ? 0 : 12 )
    else
      nil
    end
  end

  #enqueue first delivery job
  def enqueue_first_job
    user_time_zone = self.user.time_zone
    todays_time = Time.now.in_time_zone(user_time_zone)

    #check if today delivery is possible
    todays_delivery_time = Time.new(todays_time.year, todays_time.month, todays_time.day, self.delivery_time_hours, 0, 0, Time.now.in_time_zone(user_time_zone).utc_offset)
    enqueue_day = ((todays_time - todays_delivery_time) > 0) ? todays_time.tomorrow.day : todays_time.day

    #delivery time
    dtime = Time.new(todays_time.year, todays_time.month, enqueue_day, self.delivery_time_hours, 0, 0, Time.now.in_time_zone(user_time_zone).utc_offset)
    #dtime =  Time.new(todays_time.year, todays_time.month, enqueue_day , 0 , 11 , 0, Time.zone_offset(user_time_zone))

    logger.debug "The delivery time=======>" + dtime.to_s

    j = Job.create(:execution_time => dtime.utc, :status => "enqueued", :message => self.subscription_message, :recipient_number => self.user.phone)
    dj = self.delay(:run_at => dtime.utc).send_text_job(self, user_time_zone, j)
    j.delayed_job_id = dj.id
    j.save

    self.jobs << j

  end

  def send_text_job(s, z, j)

    #muted day is considered as a subscription day
    if s.mute.blank?
      #PERFORM TASK
      #todays_time = Time.now.in_time_zone(z)
      #f = File.new("/Volumes/Media/test_#{todays_time.to_s.gsub(' ' ,'_')}.txt","a")
      #f.write( s.subscription_message)
      #f.close

      #pushover
      RestClient.post "https://api.pushover.net/1/messages.json", :token => "ayUrGvK4xDvYewE7EFVXJCoMrCKeMx", :user => "nAmrvNBQ74LL9sErFPT3JiH1aquX6x", :device => "gt-i9300", :title => "Daily Dose", :message => "#{s.subscription_message}"

      #JOB STATUS UPDATE
      j.reload
      j.update(:status => "completed")

    else
      j.reload
      j.update(:status => "muted")

    end

    #account_sid = 'AC464e95aa436faa83c989a5140d8a0b66'
    #auth_token = 'a49866d0a744d8642da934997ce71f78'
    #client =Twilio::REST::Client.new account_sid, auth_token
    #client.account.messages.create(:from => "+441172001588", :body => s.subscription_message, :to => s.user.phone)


    #INCREASE COUNTER
    s.update(:messages_count => s.messages_count + 1)
    logger.debug "========messages ====>" + s.messages_count.to_s

    #NEXT JOB ENQUEUE
    if (s.messages_count.to_i < s.duration.to_i) and s.status == "active"
      todays_time = Time.now.in_time_zone(z)
      #enqueue next
      #if Rails.env == "production"
      #  dtime = todays_time + 1.day
      #else
      dtime = todays_time + 1.minute
      #end

      new_j = Job.create(:execution_time => dtime.utc, :status => "enqueued", :message => s.subscription_message, :recipient_number => s.user.phone)
      dj = s.delay(:run_at => dtime.utc).send_text_job(s, z, new_j)
      new_j.delayed_job_id = dj.id
      new_j.save

      s.jobs << new_j


    else
      #  subscription expired
      s.update(:status => "expired")
      renewal_msg = "Your affirmation service has expired. Please login at http://realmobile.se to renew your service"
      logger.debug "sending welcome message ====================>"
      #pushover
      RestClient.post "https://api.pushover.net/1/messages.json", :token => "ayUrGvK4xDvYewE7EFVXJCoMrCKeMx", :user => "nAmrvNBQ74LL9sErFPT3JiH1aquX6x", :device => "gt-i9300", :title => "Daily Dose", :message => "#{renewal_msg}"
    end

  end

  private
  def delete_enqueued_jobs
    #delete enqueued delayed jobs
    self.jobs.where(:status => "enqueued").each do |j|
      dj = Delayed::Job.find_by_id(j.delayed_job_id)
      dj.delete if dj
      j.update(:status => "job removed")
    end
  end
end
