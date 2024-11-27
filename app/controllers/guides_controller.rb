class GuidesController < ApplicationController


  def index
    if params[:query]
      @guides = Guide.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @guides = []
    end
  end

  def show; end


  def create
    if params[:category] == ""
      flash[:alert] = "Select login As"
      render :show
      return
    end
    guide = Guide.find_by!(name: params[:guide_name])
    puts "#{guide.name}"
    if guide&.authenticate(params[:password])
      session[:guide_id] = guide.id
      session[:user_category] = params[:category]
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash[:alert] = "Invalid password."
      render :show
    end
  end

  def destroy
    session[:guide_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end


end