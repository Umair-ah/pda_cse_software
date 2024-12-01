class ProjectsController < ApplicationController

  def fetch_by_program
    program = Program.find_by(name: params[:program_name])
    projects = program.present? ? program.projects.order(:title) : []

    render json: projects
  end

  def show  
    @project = Project.find(params[:id])
  end

end

