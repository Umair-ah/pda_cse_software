class ProgramsController < ApplicationController

  def show  
    @program = Program.find(params[:id])

    if session[:user_category] == "Guide"
      #@projects = @program.projects.joins(:students).where(students: { guide_id: session[:guide_id] }).uniq
      #@projects = @program.projects.joins(:batch).where(batch: {id: params[:batch_id]}).joins(:students).where(students: {guide_id: session[:guide_id]}).uniq
      @projects = @program.projects
                   .joins(:batch, :students)
                   .where(batch: { id: params[:batch_id] }, students: { guide_id: session[:guide_id] })
                   .distinct

    else
      @projects = @program.projects.order(created_at: :desc)
    end
  
    if params[:query]
      @projects  =  @program.projects.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

end