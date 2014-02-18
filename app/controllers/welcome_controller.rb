class WelcomeController < ApplicationController
  def home
    @events = Event.all
    @events_by_date = @events.group_by(&:date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @news = Post.last(5)
  end
end
