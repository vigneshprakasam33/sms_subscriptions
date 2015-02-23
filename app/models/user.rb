class User < ActiveRecord::Base
  has_many :subscriptions
  accepts_nested_attributes_for :subscriptions
  attr_accessor :terms

  validates_presence_of :name , :surname , :subscriptions , :phone
  validates_uniqueness_of :phone

  before_create :set_uuid
  after_create :welcome_message
  after_update :time_zone_updated , :if => (:time_zone_changed?)
  after_update :time_zone_updated , :if => (:phone_changed?)

  def welcome_message
    logger.debug "sending welcome message ====================>"
    welcome_msg = "Subscription activated. To mute or change delivery time, login at http://realmobile.se/signin . Your user name is #{self.phone} and password is #{self.password}"
    #pushover
    RestClient.post "https://api.pushover.net/1/messages.json" , :token => "ayUrGvK4xDvYewE7EFVXJCoMrCKeMx" , :user => "nAmrvNBQ74LL9sErFPT3JiH1aquX6x" , :device => "gt-i9300" , :title => "Daily Dose" , :message => "#{welcome_msg}"
  end

  def time_zone_updated
    #check all active subscriptions
    self.subscriptions.where(:status => "active").each do |s|
      #delete enqueued jobs and start afresh
      s.delivery_time_updated
    end

  end

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.password = SecureRandom.uuid.last(8)
  end

  def self.login(u,p)
    user = User.find_by_phone(u)
    if user and user.password == p
       return user , :success
    else
      return false , :bad_auth
    end
  end


end
