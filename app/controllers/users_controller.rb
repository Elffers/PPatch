class UsersController < ApplicationController
before_action :set_user, only: [:show, :update, :preferences]

  def show
    @user = User.find(params[:id])
  end

  def preferences
    @user = User.find(params[:id])
  end

  def email_settings
    @user = User.find(params[:id])
    @user.email_preferences = set_email_preferences
    @user.save
    flash.now.notice = "Email preferences saved!"
    render :show
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

  def set_email_preferences
    email_options = ["new_post", "event_update", "event_cancellation", "rsvp_confirmation"]
    email_preferences = {}
    email_options.each do |preference|
      email_preferences[preference] = "true" if params.has_key? preference
    end
    email_preferences
  end
end
