module Api
  class UsersController < ApplicationController
    def index
      @users = User.search(search_params).order('created_at desc')
    end

    def create
      @user = User.new(user_params)
      @user.password = params[:password]
      
      render status: :created and return if @user.save

      render json: { errors: @user.errors.to_a }, status: :unprocessable_entity
    end

    private

    def search_params
      params.permit(:email, :full_name, :metadata)
    end

    def user_params
      params.require(:user).permit(:email, :phone_number, :full_name, :password, :metadata)
    end
  end
end