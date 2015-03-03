#encoding: utf-8
class User < ActiveRecord::Base
  has_many :subscriptions , :dependent => :destroy
  has_many :config_messages , :dependent => :destroy
  accepts_nested_attributes_for :subscriptions , allow_destroy: true
  accepts_nested_attributes_for :config_messages , allow_destroy: true
  attr_accessor :terms

  validates_presence_of :name, :surname, :phone
  validates_uniqueness_of :phone
  validate :validate_subscriptions_count

  before_create :set_uuid
  after_create :welcome_message
  after_update :time_zone_updated, :if => (:time_zone_changed?)
  after_update :time_zone_updated, :if => (:phone_changed?)


  def validate_subscriptions_count
    if self.subscriptions.size < 1  and self.is_admin.blank?
      errors.add(:subscriptions, ":Need 1 or more Subscription")
    elsif self.subscriptions.size > $max_message_subscription
      errors.add(:subscriptions, ":We currently support a maximum of 3 subscriptions per number")
    end
  end
  
  def phone=(phone)
    write_attribute(:phone, phone.gsub(/[^0-9\+]/, ''))
  end

  def welcome_message
    if self.gift.blank?
      welcome_msg = ConfigMessage.find_by_message_type("welcome").content.gsub('<phone_number>' , self.phone).gsub('<password>' , self.password).gsub('<name>',self.name)
    else
      welcome_msg = ConfigMessage.find_by_message_type("welcome_gift").content.gsub('<phone_number>' , self.phone).gsub('<password>' , self.password).gsub('<name>',self.name)
    end
    logger.debug "sending welcome message ====================>"
    #pushover
    RestClient.post "https://api.pushover.net/1/messages.json", :token => "ayUrGvK4xDvYewE7EFVXJCoMrCKeMx", :user => "nAmrvNBQ74LL9sErFPT3JiH1aquX6x", :device => "gt-i9300", :title => "Daily Dose", :message => "#{welcome_msg}"
  end

  def time_zone_updated
    #check all active subscriptions
    self.subscriptions.where(:status => "active").each do |s|
      #delete enqueued jobs and start afresh
      s.delivery_time_updated
    end

  end

  def set_uuid
    self.uuid = SecureRandom.uuid.gsub(/[^0-9]/, '')
    self.password ||= SecureRandom.uuid.last(8)
  end

  def self.login(u, p)
    user = User.find_by_phone(u)
    if user and user.password == p
      return user, :success
    else
      return false, :bad_auth
    end
  end


end
