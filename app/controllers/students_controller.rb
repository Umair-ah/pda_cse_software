class StudentsController < ApplicationController

  def edit_student
    @student = Student.find(params[:student_id])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
        turbo_stream.update(
          "edit_#{@student.id}",
          partial: "edit_students_list",
          locals: {student: @student}
        )
      }
    end

  end


  def update_student
    @student = Student.find(params[:student][:student_id])
    @guide = Guide.find(session[:guide_id])
    @students = Student.all.order(:usn).where(section: @guide.section)
    if @student.update(student_params)


      respond_to do |format|
        format.turbo_stream {
          render turbo_stream:
          turbo_stream.update(
            "edit_#{@student.id}",
            partial: "students_list",
            locals: {student: @student}
            )
          }
        end
        
      end

    end


    def update_guide_and_project
      guide = Guide.find(params[:guide_id])
      program = Program.find_by(name: params[:category])
      project_id = params[:project_id]
      project_title = params[:project_title]&.to_s&.strip&.upcase
      student = Student.find_by(usn: params[:usn])

      if guide.blank? || program.blank? || project_title.blank?
        return
      end


      if !guide.blank? && !program.blank? && !project_title.blank?
        student = Student.find_or_create_by!(usn: usn) do |student|
          student.guide = guide
          student.batch_id = params[:batch_id]
        end

        guide.students

        student.update!(guide: guide)

        curr_proj = Project.find(project_id)

        curr_project.destroy

        project = Project.find_or_create_by!(batch_id: params[:batch_id] , title: project_title, guide: guide, program: program) 
        StudentsProject.find_or_create_by!(project: project, student: student)


        

      else
        redirect_to request.referrer
      end

    end

    private

    def student_params
      params.require(:student).permit(:usn, :name, :section, :c_no)
    end




end
