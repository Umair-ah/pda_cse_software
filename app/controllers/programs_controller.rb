class ProgramsController < ApplicationController

  def show  
    @program = Program.find(params[:id])
    @projects = @program.projects.joins(:students).where(students: { guide_id: session[:guide_id] }).uniq

  end
end