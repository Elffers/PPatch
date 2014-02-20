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
  end

  private
    def set_user
    @user = User.find(params[:id])
  end
end
