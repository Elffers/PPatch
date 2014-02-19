class SessionsController < ApplicationController
  # before_action :check_auth_hash

  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash[:uid]
      @user = User.find_or_create_from_omniauth(auth_hash)
      if @user && @user.email != nil
        session[:user_id] = @user.id
        flash[:notice] = "You have logged in!"
        redirect_to root_path #user show path
      elsif @user
        flash[:newuser_modal] = true
        redirect_to root_path
      else
         flash[:notice] = "Failed to save the user"
         redirect_to root_path
      end
    else
      flash[:notice] = "You do not exist!"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  # def check_auth_hash
  #   auth_hash = request.env['omniauth.auth']
  #   unless auth_hash[:uid]
  #     flash[:notice] = "You do not exist!"
  #     redirect_to root_path
  #   end

  # end

end
