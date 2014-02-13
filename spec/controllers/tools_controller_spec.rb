require 'spec_helper'

describe ToolsController do
  let!(:user) { create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      tool = create(:tool)
      get 'index'

      response.should be_success
      expect(assigns(:tools)).to eq ([tool])
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
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET show' do
    let(:tool){ create(:tool) }
    it 'assigns tool' do
      get :show, id: tool.id
      expect(assigns(:tool)).to be_an_instance_of Tool
    end
  end

  describe "POST create" do
    context "if admin" do
      before(:each) do
        user.update(admin: true)
        session[:user_id] = user.id
      end

      context "with valid attributes" do
        let(:valid_attributes) { {name: "a tool", description: "this is a rake", checkedin: true} }
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

  describe "PATCH update" do
    let(:tool) { create(:tool) }
      context "if admin" do
      before(:each) do
        user.update(admin: true)
        session[:user_id] = user.id
      end

      it "does not create a new tool" do
        tool.update(name: "this is a rake", description: "the rake is broken")
        expect { patch :update, id: tool.id, tool: tool.attributes }.to change(Tool, :count).by(0)
      end

      it "redirects to tools path" do
        tool.update(name: "this is a rake", description: "the rake is broken")
        patch :update, id: tool.id, tool: tool.attributes
        expect(flash[:notice]).to_not be_blank
      end

      it "sets flash message on failure" do
        tool.update(name: nil, description: "the rake is broken")
        patch :update, id: tool.id, tool: tool.attributes
        expect(flash[:notice]).to eq "There was a problem saving the tool."
      end
    end
  end

  describe "DELETE destroy" do
    let!(:tool) { create(:tool) }
    context "if admin" do
      before(:each) do
        user.update(admin: true)
        session[:user_id] = user.id
      end

      it "deletes a tool" do
        expect { delete :destroy, id: tool.id }.to change(Tool, :count).by(-1)
      end
    end

    context "if not admin" do
      before(:each) do
        session[:user_id] = user.id
        user.update(admin: false)
      end

      it "does not delete the tool" do
        expect { delete :destroy, id: tool.id }.to change(Tool, :count).by(0)
      end
    end
  end

  describe 'GET borrow' do
    let!(:tool) { create(:tool) }
    context 'if logged in' do
      before(:each) do
        session[:user_id] = user.id
      end
      context 'if tool is available' do
        it 'changes tool checkedin status to false' do
          #why need both factory tool and assigns(:tool) here?
          get :borrow, id: tool.id
          expect(assigns(:tool).checkedin).to eq false
        end

        it 'adds tool to user toolbox' do
          expect { get :borrow, id: tool.id }.to change(user.tools, :count).by(1)
          expect(user.tools).to include assigns(:tool)
        end
      end

      context 'if tool is not available' do
        before(:each) do
          tool.update(checkedin: false)
        end

        it 'does not add to user toolbox' do
          expect { get :borrow, id: tool.id }.to change(user.tools, :count).by(0)
        end

        it 'sets flash message' do
          get :borrow, id: tool.id
          expect(flash[:notice]).to eq "This tool is unavailable!"
        end
      end
    end

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it 'redirects to home' do
        get :borrow, id: tool.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :borrow, id: tool.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end

end
