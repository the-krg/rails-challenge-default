module AccountKeyApi
  class AccountKeysController < ApplicationController
    def create
      account_key = { 
        email: account_key_params[:email],
        account_key: SecureRandom.hex,
      }.to_json

      render json: account_key
    end

    private

    def account_key_params
      params.permit(:email, :key)
    end
  end
end