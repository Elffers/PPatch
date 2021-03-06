class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :rsvp, :flake]
  before_action :require_login, except: [:show, :index]
  before_action :valid_user, only: [:edit, :update, :destroy]
  before_action :set_rsvp, only: [:rsvp, :flake]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.host_id = current_user.id

    begin
      current_user.events << @event
      # send_email(@event)?
      flash[:notice] = "Event added!"
      redirect_to event_path(@event)
    rescue ActiveRecord::RecordInvalid
      flash[:notice] = "There was a problem saving your event."
      render :new
    end

  end

  def show
    @user = User.find(@event.host_id)
    @date = @event.date.to_time.strftime("%A, %B %d, %Y")
    @time = @event.time
  end

  def edit
  end

  def update
    if @event.update(event_params)
      # event_update_email(@event) # put in resque
      flash[:notice] = "Event successfully updated!"
      redirect_to event_path(@event)
    else
      flash[:notice] = "There was a problem updating your event!"
      render :edit
    end
  end

  def destroy
    # cancellation_update_email(@event) #put in resque
    Rsvp.where(event_id: @event.id).each {|rsvp| rsvp.destroy}
    @event.destroy
    redirect_to root_path
  end

  def rsvp
    if @rsvp
      flash[:notice] = "You have already RSVP'd for this event!"
      redirect_to event_path(@event)
    else
      if current_user.events << @event
        # rsvp_confirmation(@event)
        flash[:notice] = "You have successfully RSVPd for this event!"
        redirect_to event_path(@event)
      else
        flash[:notice] = "There was a problem RSVPing to this event!"
        redirect_to event_path(@event)
      end
    end
  end

  def flake
    if @rsvp
      if @rsvp.user_id == @event.host_id
        flash[:notice] = "You can't flake from your own event!"
        redirect_to event_path(@event)
      else
        @rsvp.destroy
        flash[:notice] = "You are a huge flake. Good job."
        redirect_to event_path(@event)
      end
    else
      flash[:notice] = "You are not RSVP'd for this event!"
      redirect_to event_path(@event)
    end
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
      redirect_to root_path
    end
  end

  def set_rsvp
    @rsvp = Rsvp.find_by(user_id: current_user.id, event_id: @event.id)
  end


  def cancellation_update_email(event)
    User.set_recipients("event_cancellation").each do |recipient|
      # WormholeMailer.event_cancellation(event.id, recipient.id).deliver
    end
  end

  def event_update_email(event)
    User.set_recipients("event_update").each do |recipient|
      Resque.enqueue(EventUpdateJob, event.id, recipient.id)
      # WormholeMailer.event_update(event.id, recipient.id).deliver
    end
  end

  def rsvp_confirmation(event)
    User.set_recipients("rsvp_confirmation").each do |recipient|
      Resque.enqueue(RsvpJob, event.id, recipient.id)
    end
  end

end
