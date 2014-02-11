class PostsController < ApplicationController
  before_action :current_user


  def index
    @posts = Post.all
  end

  def show
  end

  def new
   require_login
   require_admin
  end



  private
    def require_login
      unless session[:user_id]
        flash[:notice] = "You must be signed in"
        redirect_to sign_in_path
      end
    end

    def require_admin
      unless User.find(session[:user_id]).admin == true
        flash[:notice] = "You must be an admin."
        redirect_to posts_path
      end
    end
end
