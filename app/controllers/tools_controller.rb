class ToolsController < ApplicationController
  before_action :current_user
  before_action :require_login, only: [:new]

  def index
    @tools = Tool.all
  end

  def new
    require_admin
   @tool = Tool.new
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


  private
    def require_login
      redirect_to sign_in_path, notice: "You must be signed in." if session[:user_id].nil?
    end

    def require_admin
      unless User.find(session[:user_id]).admin == true
        flash[:notice] = "You must be an admin."
        redirect_to tools_path
      end
    end

    def tool_params
      params.require(:tool).permit(:name, :description)
    end

end
