class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:show, :index]
  before_action :valid_user, only: [:edit, :update, :destroy]


  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    user = User.find(session[:user_id])
    if user.events << @event
      flash[:notice] = "Event added!"
      redirect_to event_path(@event)
    else
      # p "invalid fields"
      flash[:notice] = "There was a problem saving your event."
      render :new
    end
  end

  def index
    @events = Event.all
  end

  def show
  end

  def edit
  end

  def update
    if @event.update(event_params)
      flash[:notice] = "Event successfully updated!"
      redirect_to event_path(@event)
    else
      p "PROBLEM"
      # p Event.last
      flash[:notice] = "There was a problem updating your event!"
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private 

  def event_params
    params.require(:event).permit(:venue, :time, :description, :name, :user_id, :created_at, :updated_at)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def require_login
    unless session[:user_id]
      # p "sign in"
      flash[:notice] = "You must be signed in." 
      redirect_to sign_in_path
    end
  end

  def valid_user
    unless session[:user_id] == @event.user.id
      # p "HELLO"
      flash[:notice] = "You are not authorized to edit this event!" 
      redirect_to events_path
    end
  end

end
