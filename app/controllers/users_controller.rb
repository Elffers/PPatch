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
    if @user.update(user_params)
      @user.email_preferences = {"registration" => "true", "event_update" => "true", "new_post" => "true"}
      @user.save
      flash[:notice] = "Email successfully saved!"
      redirect_to root_path
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      redirect_to root_path(getting_started: true)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone, :email_preferences)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_email_preferences
    {"registration" => "true", "event_update" => "true", "new_post" => "true"}
  end
end
