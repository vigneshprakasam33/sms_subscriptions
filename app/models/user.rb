class User < ActiveRecord::Base
  has_many :subscriptions
  accepts_nested_attributes_for :subscriptions
  attr_accessor :terms

  validates_presence_of :name , :surname , :subscriptions , :phone
  validates_uniqueness_of :phone

  before_create :set_uuid
  after_update :time_zone_updated , :if => (:time_zone_changed?)
  after_update :time_zone_updated , :if => (:phone_changed?)

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

end
