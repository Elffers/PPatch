class EventsController < ApplicationController
  before_action :require_login, except: [:show, :index]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

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
    params.require(:event).permit(:venue, :time, :description, :name, :user_id, :type)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def require_login
    redirect_to sign_in_path, notice: "You must be signed in." if session[:user_id].nil?
  end

end
