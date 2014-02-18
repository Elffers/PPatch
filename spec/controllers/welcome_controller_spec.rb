require 'spec_helper'

describe WelcomeController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "sets past events" do
    let!(:past_event){ create(:event, date: Date.today - 1) }
    let!(:future_event){ create(:event, date: Date.today + 1) }

    it 'does not include future event' do
      get :home
      expect(assigns(:past_events)).to_not include future_event
    end

    it 'does include past event' do
      get :home
      expect(assigns(:past_events)).to include past_event
    end
  end

  describe "sets upcoming events" do
  end

end
