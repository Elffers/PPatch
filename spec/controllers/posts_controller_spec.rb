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
    context "if admin" do
      before(:each) do
        user.update(admin: true)
        session[:user_id] = user.id
      end

     context "with valid attributes" do
          let(:valid_attributes) { {title: "a post", body: "here is the body of the post", user_id: user.id} }
          it "is a redirect" do
            post :create, post: valid_attributes
            expect(response.status).to eq 302 # This is a redirect
          end

          it "changes post count by 1" do
            expect { post :create, post: valid_attributes }.to change(Post, :count).by(1)
          end

          it "sets a flash message" do
            post :create, post: valid_attributes
            expect(flash[:notice]).to_not be_blank
          end
        end

        context "with invalid attributes" do
          it "renders the new template" do
            post :create, post: {title: nil}
            expect(response).to render_template :new
          end

          it "does not create a post" do
            expect { post :create, post: {title: nil } }.to change(Post, :count).by(0)
          end
        end

  end
end

end
