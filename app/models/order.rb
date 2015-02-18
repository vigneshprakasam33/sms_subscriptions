class Order < ActiveRecord::Base
  has_many :subscriptions
end
