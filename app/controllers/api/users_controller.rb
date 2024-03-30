module Api
  class UsersController < ApplicationController
    def index
      @users = User.search(search_params).order('created_at desc')
    end

    def create
    end

    private

    def search_params
      params.permit(:email, :full_name, :metadata)
    end
  end
end