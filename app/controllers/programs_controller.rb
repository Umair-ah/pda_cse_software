class ProgramsController < ApplicationController

  def show  
    @program = Program.find(params[:id])
    @guide = Guide.find(session[:guide_id])

    if session[:user_category] == "Guide"
      @projects = @guide.projects.where(program: params[:id]).where(batch_id: params[:batch_id]).uniq

    else
      @projects = @program.projects.joins(:batch).where(batch:{id: params[:batch_id]}).order(created_at: :desc)
    end
  
    if params[:query]
      @projects  =  @program.projects.joins(:batch).where(batch:{id: params[:batch_id]}).where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

end