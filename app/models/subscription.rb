class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :message

  attr_accessor :message_category
end
