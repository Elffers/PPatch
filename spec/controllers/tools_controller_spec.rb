require 'spec_helper'

describe ToolsController do
  let!(:user) { create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      tool = create(:tool)
      get 'index'

      response.should be_success
      expect(assigns(:tool)).to eq ([tool])
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
            expect(assigns(:tool)).to be_an_instance_of(Tool)
          end
        end
      end

    context "if not admin" do

      describe "GET new" do
        it "redirects to posts index" do
          get :new

          expect(flash[:notice]).to eq "You must be an admin."
          expect(response).to redirect_to tools_path
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
          let(:valid_attributes) { {name: "a tool", description: "this is a rake", checkedin: true, user_id: user.id} }
          it "is a redirect" do
            post :create, tool: valid_attributes
            expect(response.status).to eq 302 # This is a redirect
          end

          it "changes post count by 1" do
            expect { post :create, tool: valid_attributes }.to change(Tool, :count).by(1)
          end

          it "sets a flash message" do
            post :create, tool: valid_attributes
            expect(flash[:notice]).to_not be_blank
          end
        end

        context "with invalid attributes" do
          it "renders the new template" do
            post :create, tool: {name: nil}
            expect(response).to render_template :new
          end

          it "does not create a post" do
            expect { post :create, tool: {name: nil } }.to change(Tool, :count).by(0)
          end
        end

  end
end

end
