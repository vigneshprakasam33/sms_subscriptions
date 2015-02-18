json.array!(@messages) do |message|
  json.extract! message, :id, :content, :category
  json.url message_url(message, format: :json)
end
