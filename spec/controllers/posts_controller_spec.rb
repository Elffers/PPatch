require 'spec_helper'

describe PostsController do
  let!(:user) { create(:user) }

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

  context "if logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

    context "if admin" do

      before(:each) do
        user.update(admin: true)
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

      describe "GET new" do
        it "redirects to posts index" do
          get :new

          expect(flash[:notice]).to eq "You must be an admin."
          expect(response).to redirect_to posts_path
        end
      end

    end
  end

  context "if not logged in" do
    before(:each) do
      session[:user_id] = nil
    end

    describe "GET new" do
      it "redirects to index" do
        get :new

        expect(flash[:notice]).to eq "You must be signed in."
        expect(response).to redirect_to sign_in_path
      end
    end

  end




  describe "POST create" do
  end





end
