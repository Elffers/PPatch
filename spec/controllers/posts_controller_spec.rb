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
  end # end GET index

  describe "GET 'show'" do
    it "returns http success" do
      post = create(:post)
      get :show, id: post.id
      response.should be_success
    end
  end # end GET show

  describe "GET 'new'" do
    context "if logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      context "if admin" do
        before(:each) do
          user.update(admin: true)
        end

        it "returns http success" do
          get 'new'
          response.should be_success
          expect(assigns(:post)).to be_an_instance_of(Post)
        end

        it 'renders new template' do
          get :new
          expect(response).to render_template :new
        end
      end

      context "if not admin" do
        it "redirects to posts index" do
          get :new
          expect(flash[:notice]).to eq "You must be an admin."
          expect(response).to redirect_to posts_path
        end
      end
    end

    context "if not logged in" do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to index" do
        get :new
        expect(flash[:notice]).to eq "You must be signed in."
        expect(response).to redirect_to root_path
      end
    end
  end #end GET new

  describe "POST create" do
    context "if admin" do
      before(:each) do
        user.update(admin: true)
        session[:user_id] = user.id
      end

      context "with valid attributes" do
        let(:valid_attributes) { {title: "a post", body: "here is the body of the post", user_id: user.id} }
         before(:each) do
          ActionMailer::Base.delivery_method = :test
          ActionMailer::Base.perform_deliveries = true
          ActionMailer::Base.deliveries = []
        end

        after(:each) do
          ActionMailer::Base.deliveries.clear
        end

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

        it 'associates post with current user' do
          expect { post :create, post: valid_attributes }.to change(user.posts, :count).by(1)
          expect(assigns(:post).user).to eq user
        end

        it 'sends an email' do # maybe customize later
          expect { post :create, post: valid_attributes }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end

        xit 'sends an email to users who want email update' do
          post :create, post: valid_attributes
          p ActionMailer::Base.deliveries
          p "MAIL", PostMailer.new_post(assigns(:post).id, assigns(:user).id).deliver
          expect(ActionMailer::Base.deliveries).to_not be_empty
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
  end # end POST create

  describe "GET 'edit'" do
    let(:post){create(:post, user_id: user.id) }

    context 'if logged in' do
      context 'if admin' do
        before(:each) do
          user.update(admin:true)
          session[:user_id] = user.id
        end

        context 'if valid user' do
          it 'renders edit' do
            get :edit, id: post.id
            expect(response).to render_template :edit
          end

          it 'assigns post variable' do
            get :edit, id: post.id
            expect(assigns(:post)).to_not be_nil
          end
        end

        context 'if invalid user' do
          before(:each) do
            post.update(user_id: 1)
          end

          it 'redirects to index' do
            get :edit, id: post.id
            expect(response).to redirect_to posts_path
          end

          it 'sets flash notice' do
            get :edit, id: post.id
            expect(flash[:notice]).to eq "You are not authorized to edit this post!" 
          end
        end
      end

      context 'if not admin' do
        before(:each) do
          user.update(admin:false)
          session[:user_id] = user.id
        end

        it 'sets flash message' do
          get :edit, id: post.id
          expect(flash[:notice]).to eq "You must be an admin." 
        end

        it 'redirects to blog' do
          get :edit, id: post.id
          expect(response).to redirect_to posts_path
        end
      end
    end

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to sign in" do
        get :edit, id: post.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :edit, id: post.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end # end GET edit

  describe "PATCH 'update'" do
    let!(:post){create(:post, user_id: user.id) }

    context 'if logged in' do
      context 'if admin' do
        context 'if valid user' do
          before(:each) do
            session[:user_id] = user.id
            user.update(admin: true)
          end

          context 'with valid fields' do
            let!(:valid_attributes){ { title: "new title", body:"New body" } }
            
            it 'redirects to post show page' do
              patch :update, id: post.id, post: valid_attributes
              expect(response).to redirect_to post_path(post)
            end

            it 'does not add post to database' do
              expect {patch :update, id: post.id, post: valid_attributes }.to change(Post, :count).by(0)
            end

          end

          context 'with invalid fields' do
            let(:invalid_attributes){ { body: ""} }
            it 'renders edit' do
              patch :update, id: post.id, post: invalid_attributes
              expect(response).to render_template :edit
            end

            it 'does not add post' do
              expect { patch :update, id: post.id, post: invalid_attributes }.to change(Post, :count).by(0)
            end

          end
        end

        context 'if invalid user' do
          let(:hacker){ create(:user, admin: true)}
          before(:each) do
            session[:user_id] = hacker.id
            # post.update(user_id: 1)
          end

           it 'is redirects to post show' do
            patch :update, id: post.id
            expect(response).to redirect_to posts_path
          end

          it 'sets flash message' do
            patch :update, id: post.id
            expect(flash[:notice]).to eq "You are not authorized to edit this post!" 
          end
        end
      end
    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :edit, id: post.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :edit, id: post.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end #end patch update

  describe "DELETE 'destroy'" do
    let!(:post) { create(:post, user_id: user.id) }
    context 'if logged in' do
      
      context "if admin" do
        before(:each) do
          user.update(admin: true)
          session[:user_id] = user.id
        end

        context 'if valid user' do
          it "deletes a post" do
            expect { delete :destroy, id: post.id }.to change(Post, :count).by(-1)
          end

          it "removes post from admin's posts" do
            expect { delete :destroy, id: post.id }.to change(user.posts, :count).by(-1)
          end
        end #end if valid user

        context 'if invalid user' do
          before(:each) do
            post.update(user_id: 1)
          end

          it 'does not delete post' do
            expect { delete :destroy, id: post.id }.to change(Post, :count).by(0)
          end

          it 'sets flash message' do
            delete :destroy, id: post.id
            expect(flash[:notice]).to eq "You are not authorized to edit this post!" 
          end
        end #end if invalid user
      end # end if admin

      context "if not admin" do
        before(:each) do
          session[:user_id] = user.id
          user.update(admin: false)
        end

        it "does not delete the post" do
          expect { delete :destroy, id: post.id }.to change(Post, :count).by(0)
        end

        it 'sets flash message' do
          delete :destroy, id: post.id
          expect(flash[:notice]).to eq "You must be an admin."
        end
      end #end if not admin
    end #end if logged in

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to sign in" do
        delete :destroy, id: post.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        delete :destroy, id: post.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end # end if logged in
  end # end DELETE destroy
end

