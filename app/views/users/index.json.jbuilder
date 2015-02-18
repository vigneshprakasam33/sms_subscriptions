json.array!(@users) do |user|
  json.extract! user, :id, :name, :surname, :phone, :password, :email, :time_zone
  json.url user_url(user, format: :json)
end
