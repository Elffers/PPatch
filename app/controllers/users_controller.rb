class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def preferences
    @user = User.find(params[:id])
  end
end
