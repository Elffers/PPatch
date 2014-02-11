class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:show, :index]
  before_action :require_admin, only: [:edit, :update, :destroy]


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
  end

  def destroy
  end

  private 

  def event_params
    params.require(:event).permit(:venue, :time, :description, :name, :user_id)
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

  def require_admin
    unless session[:user_id] == @event.user.id
      p "HELLO"
      flash[:notice] = "You are not authorized to edit this list!" 
      redirect_to events_path
    end
  end

end
