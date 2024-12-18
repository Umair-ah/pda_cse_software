class PointsController < ApplicationController

  def show
    @point = Point.find(params[:id])
  end

  def update
    @point = Point.find(params[:id])
    if @point.update(point_params)
      if @point.presentation.project.guides.exists?(id: Guide.find(session[:guide_id]).id)
        @point.presentation.project.update(title: @point.project_title&.to_s&.strip&.upcase)
      end
      redirect_to request.referrer, notice: "Total Done"
    else 
      flash[:alert] = "give marks under proper range."
      render :show, status: :unprocessable_entity
    end
  end


  private

  def point_params
    params.require(:point).permit(:guide_name, :student_name, :student_usn, :project_title, :mark1, :mark2, :mark3, :mark4, :mark5, :total, :locked, :presentation_id)  
  end
end