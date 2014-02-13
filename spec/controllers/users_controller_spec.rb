require 'spec_helper'

describe UsersController do
  let(:user){ create(:user)}

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: user.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
