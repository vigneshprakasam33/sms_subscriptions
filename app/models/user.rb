class User < ActiveRecord::Base
  has_many :subscriptions
  accepts_nested_attributes_for :subscriptions

  after_update :time_zone_updated , :if => (:time_zone_changed?)
  after_update :time_zone_updated , :if => (:phone_changed?)

  def time_zone_updated
    #check all active subscriptions
    self.subscriptions.where(:status => "active").each do |s|
      #delete enqueued jobs and start afresh
      s.delivery_time_updated
    end

  end

end
