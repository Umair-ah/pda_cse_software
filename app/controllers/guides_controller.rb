class GuidesController < ApplicationController

  def index_two
    @guides = Guide.where(type: "Coordinator").order(created_at: :asc)
  end

  def show_two
    @guide = Guide.find(params[:guide_id])
  end

  def update_two
    @guide = Guide.find(params[:coordinator][:guide_id])
  
    if params[:coordinator][:password].present?
      # Only update the password if it's provided
      if @guide.update(name: params[:coordinator][:name], password: params[:coordinator][:password])
        redirect_to index_two_guides_path, notice: "Password updated successfully"
      else
        render :show_two, status: :unprocessable_entity
      end
    else
      # Update only the name if no password is provided
      if @guide.update(name: params[:coordinator][:name]) && @guide.update(section: params[:coordinator][:section])
        redirect_to index_two_guides_path, notice: "Name and Section updated successfully"
      else
        render :show_two, status: :unprocessable_entity
      end
    end

  end



  def index
    if params[:query]
      @guides = Guide.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @guides = []
    end
  end

  def show
    @guide = Guide.find_by(name: params[:guide_name])
  end


  def create
    guide = Guide.find_by!(name: params[:guide_name])
    
    if guide.type.nil?
      if params[:category] == ""
        flash[:alert] = "Select login As"
        redirect_to request.referrer
        return
      end
    end

    puts "#{guide.name}"
    if guide&.authenticate(params[:password])
      session[:guide_id] = guide.id
      session[:user_category] = params[:category]
      redirect_to batches_path, notice: "Logged in successfully."
    else
      flash[:alert] = "Invalid password."
      redirect_to request.referrer
    end

  end

  def destroy
    session[:guide_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end


end