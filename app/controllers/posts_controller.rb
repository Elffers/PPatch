class PostsController < ApplicationController
  before_action :current_user
  before_action :require_login, only: [:new]
  before_action :set_post, only: [:show, :update, :destroy, :edit]


  def index
    @posts = Post.all
  end

  def show
  end

  def edit
  end

  def new
   require_admin
   @post = Post.new
  end

  def create
    @post  = Post.new(post_params)
    user = User.find(session[:user_id])
    if user.posts << @post
      flash[:notice] = "Post has been successfully created."
      redirect_to post_path(@post)
    else
      flash[:notice] = "There was a problem saving the post."
      render :new
    end
  end

def update
      @post.update(post_params)
      if @post.save
        flash[:notice] = "Post has been successfully updated."
        redirect_to post_path(@post)
      else
        flash[:notice] = "There was a problem saving the post."
       redirect_to post_path(@post)
      end
    end

    def destroy
      @post.destroy
      flash[:notice] = "Post has been successfully deleted."
      redirect_to posts_path
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

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end
end
