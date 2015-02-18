class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :message
  belongs_to :category

  attr_accessor :message_category
end
