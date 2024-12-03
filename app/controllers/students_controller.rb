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


    def update_guide
     

    end

    private

    def student_params
      params.require(:student).permit(:usn, :name, :section, :c_no)
    end




end
