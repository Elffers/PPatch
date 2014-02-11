require 'spec_helper'

describe PostsController do
  let(:user) { create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      post = create(:post)
      get 'index'

      response.should be_success
      expect(assigns(:posts)).to eq ([post])
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  context "if admin" do

    before(:each) do
      user.update(admin: true)
      session[:user_id] = user.id
    end

    describe "GET 'new'" do
     it "returns http success" do
       get 'new'

      response.should be_success
      expect(assigns(:post)).to be_an_instance_of(Post)
     end
    end
end

  context "if not admin" do
    before(:each) do
      session[:user_id] = user.id
    end

  describe "GET new" do
    it "redirects to index" do
      get :new
      expect(response).to redirect_to posts_path
    end
  end
end

end
