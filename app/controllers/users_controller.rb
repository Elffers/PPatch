class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :preferences, :update_email_settings]

  def show
    @user = User.find(params[:id])
  end

  def preferences
    if !@user.email
      flash.now.notice = "You must register a valid email address!"
      render partial: "welcome/modal"
    end
  end

  def update_email_settings
    if @user.email
      # @user.update_email_preferences(email_settings)
      flash.now.notice = "Email preferences saved!"
      render :show
    else
      flash.notice = "You must register a valid email address!"
      redirect_to user_path(@user)
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Email address saved!"
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

  def email_settings
    email_options = ["new_post", "event_update", "event_cancellation", "rsvp_confirmation"]
    preferences = {}
    email_options.each do |option|
      preferences[option] = "true" if params.has_key? option
    end
    preferences
  end
end
