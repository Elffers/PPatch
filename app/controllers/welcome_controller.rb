class WelcomeController < ApplicationController
  def home
    barometer = Barometer.new('Seattle')
    @weather = barometer.measure
  end
end
