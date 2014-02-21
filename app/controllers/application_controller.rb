class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user || User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user


  def weather
    barometer = Barometer.new('Seattle') #maybe have this as an AJAX call so it doesn't clog up reloads?
    @weather = barometer.measure
  end

  helper_method :weather

end
