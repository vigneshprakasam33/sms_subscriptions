json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :order_id, :subscription_message, :message_id, :frequency, :delivery_time, :gift
  json.url subscription_url(subscription, format: :json)
end
