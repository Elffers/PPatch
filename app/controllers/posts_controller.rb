class PostsController < ApplicationController
  before_action :current_user
  before_action :require_login, only: [:new]


  def index
    @posts = Post.all
  end

  def show
  end

  def new
   require_admin
   @post = Post.new
  end



  private
    def require_login
      redirect_to sign_in_path, notice: "You must be signed in." if session[:user_id].nil?
    end

    def require_admin
      unless User.find(session[:user_id]).admin == true
        flash[:notice] = "You must be an admin."
        redirect_to posts_path
      end
    end
end
