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

      it "redirects to home page" do
        get :create
        expect(response).to redirect_to root_path
      end
    end

    context 'if new user' do
      it "creates a user" do
        expect { get :create }.to change(User, :count).by(1)
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

      context "when failing to save the user" do
        before {
          request.env["omniauth.auth"] = {:uid => "",
                                          :info => {name:"hello", image: "blah"},
                                          :credentials => {secret:"", token: ""}
                                          }
        }

        it "redirect to home with flash error" do
          create(:user, name:"UNIQ")
          get :create
          expect(response).to redirect_to root_path
          expect(flash[:notice]).to eq "Failed to save the user"
        end
      end

  end

end
