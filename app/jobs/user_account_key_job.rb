require 'account_key_service'

class ServiceError < StandardError; end

class UserAccountKeyJob < ApplicationJob
  retry_on ServiceError

  def perform(email, key)
    user = User.find_by(email: email)

    if user
      response = AccountKeyService.new(email, key).generate

      if response.code == "200"
        account_key = JSON.parse(response.body)["account_key"]

        user.update(account_key: account_key) if account_key
      else
        raise ServiceError
      end
    end
  end
end