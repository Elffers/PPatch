require 'spec_helper'

describe WelcomeController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "sets events" do
    let!(:past_event){ create(:event, date: Date.today - 1) }
    let!(:future_event){ create(:event, date: Date.today + 1) }

    context 'sets past events' do
      it 'does not include future event' do
        get :home
        expect(assigns(:past_events)).to_not include future_event
      end

      it 'does include past event' do
        get :home
        expect(assigns(:past_events)).to include past_event
      end
    end

    context "sets upcoming events" do
      it 'does not include future event' do
        get :home
        expect(assigns(:upcoming_events)).to include future_event
      end

      it 'does include past event' do
        get :home
        expect(assigns(:upcoming_events)).to_not include past_event
      end
    end
  end

end
