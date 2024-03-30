require 'net/http'

class AccountKeyService
  BASE_URL = 'http://localhost:3000'

  def initialize(email, key)
    @email = email
    @key = key
  end

  def generate
    Net::HTTP.post(uri, body, headers)
  end

  private

  attr_reader :email, :key
  
  def body
    {
      email: email,
      key: key,
    }.to_json
  end

  def uri
    URI.parse("#{BASE_URL}/account_key_api/account")
  end

  def headers
    { 'Content-Type': 'application/json' }
  end
end