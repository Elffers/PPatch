class UsersController < ApplicationController
before_action :set_user, only: [:show, :update, :preferences]

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def preferences
    @user = User.find(params[:id])
  end

  def update
    @user.update(user_params)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone, :email_preferences)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
