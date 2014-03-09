class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash[:uid]
      @user = User.find_or_create_from_omniauth(auth_hash)
      if @user && @user.email.nil?
        session[:user_id] = @user.id
        redirect_to root_path(getting_started: true)
      else
        session[:user_id] = @user.id
        flash[:notice] = "You have logged in!"
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
end
