class ToolsController < ApplicationController
  before_action :current_user
  before_action :require_login, except: [:show, :index]
  before_action :require_admin, only: [:new, :create, :destroy] #need edit, update
  before_action :set_tool, only: [:show, :update, :destroy, :borrow, :return]

  def index
    @tools = Tool.all
  end

  def new
   @tool = Tool.new
  end

  def show
  end

  def create
    @tool  = Tool.new(tool_params)
    if @tool.save
      flash[:notice] = "Tool has been successfully created."
      redirect_to tools_path
    else
      flash[:notice] = "There was a problem saving the tool."
      render :new
    end
  end

  def update
    @tool.update(tool_params)
    if @tool.save
      flash[:notice] = "Tool has been successfully updated."
      redirect_to tools_path
    else
      flash[:notice] = "There was a problem saving the tool."
     redirect_to tools_path
    end
  end

  def destroy
    @tool.destroy
    flash[:notice] = "Tool has been successfully deleted."
    redirect_to tools_path
  end

  def borrow
    if @tool.checkedin == true
      @tool.update(checkedin: false, user_id: current_user.id)
      if @tool.save
        flash[:notice] = "You have successfully checked out #{@tool.name}!"
        redirect_to tools_path
      end
    else
      flash[:notice] =  "This tool is unavailable!"
      redirect_to tools_path
    end
  end

  def return
    if @tool.checkedin == false
      @tool.update(checkedin: true, user_id: nil)
      if @tool.save
        flash[:notice] = "Tool successfully returned!"
        redirect_to tools_path
      end
    else
      flash[:notice] = "This tool is already checked in!"
      redirect_to tools_path
    end
  end

  private
  
  def require_login
    redirect_to root_path, notice: "You must be signed in." if session[:user_id].nil?
  end

  def require_admin
    unless User.find(session[:user_id]).admin == true
      flash[:notice] = "You must be an admin."
      redirect_to tools_path
    end
  end

  def tool_params
    params.require(:tool).permit(:name, :description, :checkedin)
  end

  def set_tool
    @tool = Tool.find(params[:id])
  end
end
