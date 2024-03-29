json.users @users do |user|
  json.email user.email
  json.phone_number user.phone_number
  json.full_name user.full_name
  json.key user.key
  json.account_key user.account_key
  json.metadata user.metadata
end