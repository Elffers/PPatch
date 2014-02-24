class ToolsController < ApplicationController
  before_action :current_user
  before_action :require_login, except: [:show, :index]
  before_action :require_admin, only: [:new, :create, :destroy] #need edit, update
  before_action :set_tool, only: [:show, :update, :destroy, :borrow, :return]

  def index
    @tools = Tool.all
    @tool = Tool.new
  end

  def create
    @tool  = Tool.new(tool_params)
    if @tool.save
       respond_to do |format|

        format.html { redirect_to tools_path }
        format.json { render json: @tool.as_json }
      end
    else
      redirect_to tools_path
    end
  end


  def update
    @tool.update(tool_params)
    if @tool.save
      if @tool.save

        respond_to do |format|
          format.html { redirect_to :back }
          format.json { render json: @tool.as_json }
        end
      else
        render :back
    end
  end
end

  def destroy
    @tool.destroy
    respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
  end

  def borrow
    if @tool.checkedin == true
      if @tool.update(checkedin: false, user_id: current_user.id)
        respond_to do |format|
          format.html { redirect_to tools_path, notice: "You have successfully checked out #{@tool.name}!"  }
          format.json { render json: @tool }
        end
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
