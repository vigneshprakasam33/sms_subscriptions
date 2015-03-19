json.array!(@supports) do |support|
  json.extract! support, :id, :email, :content
  json.url support_url(support, format: :json)
end
