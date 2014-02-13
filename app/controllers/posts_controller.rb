class PostsController < ApplicationController
  before_action :current_user
  before_action :require_login, except: [:show, :index]
  before_action :require_admin, except: [:show, :index]
  before_action :set_post, only: [:show, :update, :edit, :destroy]
  before_action :valid_user, only: [:update, :edit, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
   @post = Post.new
  end

  def create
    @post  = Post.new(post_params)
    @user = User.find(session[:user_id])
    if @user.posts << @post
      PostMailer.new_post(@post.id, @user.id).deliver #right now only delivers to the post owner
      flash[:notice] = "Post has been successfully created."
      redirect_to post_path(@post)
    else
      flash[:notice] = "There was a problem saving the post."
      render :new
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    if @post.save
      flash[:notice] = "Post has been successfully updated."
      redirect_to post_path(@post)
    else
      flash[:notice] = "There was a problem saving the post."
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post has been successfully deleted."
    redirect_to posts_path
  end

  private

  def require_login
    redirect_to root_path, notice: "You must be signed in." unless session[:user_id]
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

  def valid_user
    unless session[:user_id] == @post.user_id
      flash[:notice] = "You are not authorized to edit this post!" 
      redirect_to posts_path
    end
  end
  
end
