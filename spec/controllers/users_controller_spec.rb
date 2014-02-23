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
  end

end
