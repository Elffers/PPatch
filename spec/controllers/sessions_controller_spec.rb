require 'spec_helper'

describe SessionsController do
  describe 'sign in process' do
    before(:each) do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end

    context 'if user exists' do
    let!(:user) { User.find_or_create_from_omniauth(OmniAuth.config.mock_auth[:twitter]) }

      it 'assigns user to current user' do
        get :create
        expect(session[:user_id]).to eq assigns(:user).id
      end

      it "doesn't create another user" do
        expect { get :create }.to_not change(User, :count).by(1)
      end

      context "user has empty contact profile" do
         it "redirects to home page" do
          get :create
          expect(response).to redirect_to root_path(getting_started: true)
        end
      end

      context "user has filled out contact info" do
        it "redirects to home page" do
          complete_user = user.update(email: "hello@example.com")
          get :create
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'if new user' do
      it "creates a user" do
        expect { get :create }.to change(User, :count).by(1)
      end

      it "redirects to home page with getting started param" do
        get :create
        expect(response).to redirect_to root_path(getting_started: true)
      end

    end


    context "fails on twitter" do
      before(:each) do
        request.env["omniauth.auth"] = {"uid" => nil, "info" => {} }
      end

      it "redirect to home with flash error" do
        get :create
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq "You do not exist!"
      end
    end
  end

  describe 'sign out process' do
    it 'sets session user id to nil' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to home' do
      delete :destroy
      expect(response).to redirect_to root_path
    end

  end


end
