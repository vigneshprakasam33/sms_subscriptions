json.array!(@orders) do |order|
  json.extract! order, :id, :payment_method, :price, :status
  json.url order_url(order, format: :json)
end
