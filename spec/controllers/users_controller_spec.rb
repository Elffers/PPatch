require 'spec_helper'

describe UsersController do
  let(:user){ create(:user)}

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: user.id
      response.should be_success
    end

    it 'should assign user' do
      get 'show', id: user.id
      expect(assigns(:user)).to_not be_nil
    end
  end

  describe "GET 'preferences'" do
    context 'if user has saved email address' do
      it "should render partial" do
        get 'preferences', id: user.id
        expect(response).to render_template :preferences 
      end
    end

    context 'if user does not have email saved' do
      before(:each) do
        user.update(email: nil, email_preferences: nil)
      end
      xit 'should render email update partial' do
        get 'preferences', id: user.id
        p user
        expect(response).to render_template partial:'welcome/modal'
      end 
    end
  end

  describe "POST 'email settings" do
    context 'if user has saved email address' do
      let(:email_preferences){ {"new_post" => "true"} } #use stub here for set_email preference?
      it 'should render show' do
        post :update_email_settings, id: user.id
        expect(response).to render_template :show
      end

      it 'should set flash message' do
        post :update_email_settings, id: user.id
        expect(flash[:notice]).to eq "Email preferences saved!"
      end

      it 'should change user email preferences' do
        post :update_email_settings, id: user.id
        expect(user.email_preferences).to eq email_preferences
      end

    end

    context 'if user does not have email saved' do
      before(:each) do
        user.update(email: nil, email_preferences: nil)
      end

      it 'should redirect to user show' do
        post :update_email_settings, id: user.id
        expect(response).to redirect_to user_path(user)
      end

      it 'should set flash message' do
        post :update_email_settings, id: user.id
        expect(flash[:notice]).to eq "You must register a valid email address!"
      end
    end
  end

end
