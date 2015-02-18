class User < ActiveRecord::Base
  has_many :subscriptions
  accepts_nested_attributes_for :subscriptions
end
