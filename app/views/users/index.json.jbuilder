json.array!(@users) do |user|
  json.extract! user, :id, :loginable_id, :loginable_type, :username, :email, :full_name, :roles, :reset_token
  json.url user_url(user, format: :json)
end
