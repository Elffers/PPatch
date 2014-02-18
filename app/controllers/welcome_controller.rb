class WelcomeController < ApplicationController
  def home
    barometer = Barometer.new('Seattle')
    @weather = barometer.measure
    @events = Event.all
    @events_by_date = @events.group_by(&:date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end
end
