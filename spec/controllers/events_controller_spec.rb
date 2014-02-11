require 'spec_helper'

describe EventsController do
  let(:user){ create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "shows all events" do
      event = create(:event)
      get 'index'
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET 'show'" do
    let(:event){ create(:event)}
    it "returns http success" do
      get 'show', id: event.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    context 'if logged in' do
      before(:each) do
        session[:user_id] = user.id
      end

      it "returns http success" do
        get :new
        response.should be_success
      end
    end

    context 'if not logged in' do
      it "redirects to home" do
        get :new
        expect(response).to redirect_to sign_in_path
      end

      it 'sets flash message' do
        get :new
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end


end
