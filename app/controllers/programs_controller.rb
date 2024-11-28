class ProgramsController < ApplicationController

  def show  
    @program = Program.find(params[:id])

    if session[:user_category] == "Guide"
      @projects = @program.projects.joins(:students).where(students: { guide_id: session[:guide_id] }).uniq
    else
      @projects = Project.all.order(created_at: :desc)
    end

  end
end