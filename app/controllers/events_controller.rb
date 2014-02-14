class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :rsvp]
  before_action :require_login, except: [:show, :index]
  before_action :valid_user, only: [:edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.host_id = current_user.id

    begin
      current_user.events << @event
      flash[:notice] = "Event added!"
      redirect_to event_path(@event)
    rescue ActiveRecord::RecordInvalid 
      flash[:notice] = "There was a problem saving your event."
      render :new
    end

  end

  def index
    @events = Event.all
    @events_by_date = @events.group_by(&:date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show
    @user = User.find(@event.host_id)
    @date = @event.date.to_time.strftime("%A, %B %d, %Y")
    @time = @event.time
    #@event.time.in_time_zone('Pacific Time (US & Canada)').strftime("%l:%M %p")
    # maybe save time as string?
  end

  def edit
  end

  def update
    if @event.update(event_params)
      flash[:notice] = "Event successfully updated!"
      redirect_to event_path(@event)
    else
      flash[:notice] = "There was a problem updating your event!"
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  def rsvp
    @rsvp = Rsvp.find_by(user_id: current_user.id, event_id: @event.id)
    if @rsvp
      flash[:notice] = "You have already RSVP'd for this event!"
      redirect_to event_path(@event)
    else
      if current_user.events << @event
        flash[:notice] = "You have successfully RSVPd for this event!"
        redirect_to event_path(@event)
      else
        flash[:notice] = "There was a problem RSVPing to this event!"
        redirect_to event_path(@event)
      end
    end
  end

  def flake
  end

  private 

  def event_params
    params.require(:event).permit(:venue, :time, :description, :name, :date)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def require_login
    unless session[:user_id]
      flash[:notice] = "You must be signed in." 
      redirect_to root_path
    end
  end

  def valid_user
    unless session[:user_id] == @event.host_id
      flash[:notice] = "You are not authorized to edit this event!" 
      redirect_to events_path
    end
  end

end
