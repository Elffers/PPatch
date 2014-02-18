class WelcomeController < ApplicationController
  before_action :past_events
  before_action :upcoming_events

  def home
    barometer = Barometer.new('Seattle')
    @weather = barometer.measure
    @events = Event.all
    @events_by_date = @events.group_by(&:date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  private
  def past_events
    @past_events = Event.all.keep_if {|event| event.date < Date.today}
  end

  def upcoming_events
    @upcoming_events = Event.all.keep_if {|event| event.date > Date.today}
  end
end
