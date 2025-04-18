class BatchesController < ApplicationController

  def preview_guides_in_html
    @guides_preview = session[:guides_preview]
  end

  def preview_guides
    if params[:file].nil? || params[:category] == ""
      redirect_to request.referrer, alert: "No file uploaded Or No Project Type Selected. Please upload a file and try again."
      return
    end
  
    file_path = params[:file].path
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(0)
  
    @guides_preview = []
    current_guide_name = nil
    current_project_title = nil
  
    sheet.each_with_index do |row, index|
      next if index < 9 # Skip the header rows
  
      # Extract data
      name = row[1]&.to_s&.strip&.upcase
      usn = row[2]&.to_s&.strip&.upcase
      project_title = row[3]&.to_s&.strip&.upcase
      guide_name = row[4]&.to_s&.strip&.upcase
  
      # Update current guide and project titles if new ones are found
      current_guide_name = guide_name.present? ? guide_name : current_guide_name
      current_project_title = project_title.present? ? project_title : current_project_title
  
      # Add row data to preview
      @guides_preview << {
        name: name,
        usn: usn,
        project_title: current_project_title,
        guide_name: current_guide_name
      }
    end
  
    session[:guides_preview] = @guides_preview
    session[:batch_id] = params[:batch_id]
    session[:category_proj] = params[:category]
  
    redirect_to preview_guides_in_html_batches_path, notice: "Preview generated successfully!"
  end
  
  def confirm_guides
    guides_preview = session[:guides_preview]
    batch_id = session[:batch_id]
    category = session[:category_proj]
  
    if guides_preview.nil? || batch_id.nil? || category.nil?
      redirect_to show_two_batches_path, alert: "No data to save. Please upload again."
      return
    end
  
    program = Program.find_by(name: category)
  
    guides_preview.each do |guide_data|
      guide = Guide.find_or_create_by!(name: guide_data[:guide_name]) do |g|
        g.password = "pda123"
      end
  
      student = Student.find_or_create_by!(usn: guide_data[:usn]) do |s|
        s.name = guide_data[:name]
        s.batch_id = batch_id
      end
  
      project = Project.find_or_create_by!(batch_id: batch_id, title: guide_data[:project_title], program: program)
  
      StudentsProjectsGuide.find_or_create_by!(project: project, student: student, guide: guide)
  
      2.times do |i|
        presentation = Presentation.find_or_create_by!(student: student, name: "Presentation #{i + 1}", program: program) do |pre|
          pre.project = project
          pre.sequence = i + 1
        end
  
        3.times do |j|
          Point.find_or_create_by!(presentation: presentation, guide_name: "Change Name #{j + 1}")
        end
      end
    end
  
    session[:guides_preview] = nil
    session[:batch_id] = nil
    session[:category_proj] = nil
  
    redirect_to batches_path, notice: "Guides imported successfully!"
  end
  
  def cancel_guides
    redirect_to batch_show_two_path(session[:batch_id]), notice: "Guide import canceled."
    session[:guides_preview] = nil
    session[:batch_id] = nil
    session[:category_proj] = nil
  
  end
  

  def preview_students_in_html
    @students = session[:students_preview]

  end

  def preview_students
    if params[:file].nil?
      redirect_to batch_path(params[:batch_id]), alert: "No file uploaded. Please upload a file and try again."
      return
    end

    file_path = params[:file].path
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(0)
    
    @students = []

    # Skip header rows (assume headers are in the first 7 rows)
    sheet.each_with_index do |row, index|
      next if index < 6
      
      usn = row[1]&.to_s&.strip&.upcase
      name = row[2]&.to_s&.strip&.upcase
      c_no = row[3]&.to_s&.strip&.upcase
      
      @students << { usn: usn, name: name, c_no: c_no }
    end

    session[:students_preview] = @students
    session[:batch_id] = params[:batch_id]
    redirect_to preview_students_in_html_batches_path
  end

  def confirm_students
    students = session[:students_preview]
    batch_id = session[:batch_id]

    if students.nil? || batch_id.nil?
      redirect_to batches_path, alert: "No data to save. Please upload again."
      return
    end

    students.each do |student_data|
      student = Student.find_or_create_by!(usn: student_data[:usn]) do |student|
        student.name = student_data[:name]
        student.c_no = student_data[:c_no]
        student.section = Guide.find(session[:guide_id]).section
        student.batch_id = batch_id
      end

      student.update!(c_no: student_data[:c_no]) if student.c_no.blank?
      student.update!(batch_id: batch_id) if student.batch_id.blank?
    end

    session[:students_preview] = nil
    session[:batch_id] = nil

    redirect_to batch_path(batch_id), notice: "Students imported successfully!"
  end

  def cancel_students
    session[:students_preview] = nil
    session[:batch_id] = nil

    redirect_to batches_path, notice: "Student import canceled."
  end







  

  def change_teammate_post
    if params[:new_project_id].blank?
      return
    end

    existing_project_id = params[:existing_project_id]
    new_project_id = params[:new_project_id]
    student_id = params[:student_id]
    guide_id = params[:guide_id]

    StudentsProjectsGuide.find_by(project_id: existing_project_id, student_id: student_id, guide_id: guide_id).destroy
    new_guide = StudentsProjectsGuide.find_by(project_id: new_project_id).guide
    StudentsProjectsGuide.create(project_id: new_project_id, student_id: student_id, guide: new_guide)

    redirect_to request.referrer, notice: "Changed the student's project!"
  end


  def assign_guides_manually_post
    project_title = params[:project_title]
    batch_id = params[:batch_id]
    guide_id = params[:guide_id]
    program = Program.find_by(name: params[:program])
    student_ids = params[:student_ids]

    if project_title.blank? || guide_id.blank? || student_ids.blank?
      redirect_to request.referrer, alert: "fill all the details"
      return
    end
  
    guide = Guide.find(guide_id)
  
    student_ids = student_ids.map(&:to_i)
  
    begin
      ActiveRecord::Base.transaction do
        student_ids.each_with_index do |s, i|
          student = Student.find(s)
          project = Project.create!(batch_id: batch_id, title: project_title, program: program)
  
          StudentsProjectsGuide.find_or_create_by!(project: project, student: student, guide: guide)
  
          2.times do |i|
            presentation = Presentation.find_or_create_by!(student: student, name: "Presentation #{i + 1}", program: program) do |pr|
              pr.project = project
            end
  
            if presentation.points.size == 3
              raise ActiveRecord::Rollback, "Too many points for presentation #{presentation.name}"
            else
              3.times do |j|
                Point.find_or_create_by!(presentation: presentation, guide_name: "Change Name #{j + 1}")
              end
            end
          end
        end
      end
  
  
    rescue ActiveRecord::Rollback => e
      success = false
      flash[:alert] = "Something went wrong: #{e.message}"
      redirect_to request.referer || batches_path 
    end

    if success
      redirect_to request.referer, notice: 'Guides assigned and projects created successfully.'
    else
      redirect_to request.referer || batches_path, alert: 'Something went wrong. Please try again.'
    end
  end
  
  

  def index_two
    @guide = Guide.find(session[:guide_id])
    #@projects = Project.where(batch_id: params[:batch_id])
    @projects = Project.includes(:students, presentations: :points).where(batch_id: params[:batch_id])

  end

  def show_two
    @guides = Guide.all.where(type: nil)
  end

  def import_guides
    if params[:file].nil?
      redirect_to show_two_batches_path, alert: "No file uploaded. Please upload a file and try again."
      return
    end

    file_path = params[:file].path
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(0)
  
    # Initialize variables to store the current guide and project values
    current_guide_name = nil
    current_project_title = nil
  
    sheet.each_with_index do |row, index|
      next if index < 9  # Skip the header or any initial rows if needed
  
      # Read data from the row
      name = row[1]&.to_s&.strip&.upcase
      usn = row[2]&.to_s&.strip&.upcase
      project_title = row[3]&.to_s&.strip&.upcase
      guide_name = row[4]&.to_s&.strip&.upcase

      # Skip rows with invalid or missing guide_name
      # if guide_name.blank?
      #   puts "Skipping row ##{index + 1}: Guide name is blank or invalid"
      #   next
      # end
  
      # Update current guide name if it has changed
      current_guide_name = guide_name.present? ? guide_name : current_guide_name
      current_project_title = project_title.present? ? project_title : current_project_title
  
      # Ensure guide exists or is created
      guide = Guide.find_or_create_by!(name: current_guide_name) do |guide|
        guide.password = "pda123"
      end
  
      # Find the program based on the provided category
      program = Program.find_by(name: params[:category])

      
      # Ensure student exists or is created
      student = Student.find_or_create_by!(usn: usn) do |student|
        student.name = name
        #student.guide = guide
        student.batch_id = params[:batch_id]
      end

      project = Project.find_or_create_by!(batch_id: params[:batch_id] , title: current_project_title, program: program) 

      StudentsProjectsGuide.find_or_create_by!(project: project, student: student, guide: guide)
      

      2.times do |i|
        presentation = Presentation.find_or_create_by!(student: student, name: "Presentation #{i + 1}", program: program) do |pre|
          pre.project = project
          pre.sequence = i+1
        end

        3.times do |j|
          Point.find_or_create_by!(presentation: presentation, guide_name:"Change Name #{j + 1}")
        end
      end
    end
    redirect_to batches_path, notice: "Guides imported successfully!"
  end
  
  

  def show
    if session[:guide_id].nil?
      @students = Student.all.order(:usn)
      return
    end

    @guide = Guide.find(session[:guide_id])
    if @guide.type == "Coordinator"
      @students = Student.all.order(:usn).where(section: @guide.section).or(Student.where(section: nil)).order(created_at: :asc)
    else
      @programs = Program.limit(2)
    end
    
  end



  def import_students

    if params[:file].nil?
      redirect_to batch_path(params[:batch_id]), alert: "No file uploaded. Please upload a file and try again."
      return
    end

    file_path = params[:file].path # Assuming the file is uploaded as 'params[:file]'
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(0) # Access the first sheet
  
    # Skip header rows (assume headers are in the first 7 rows)
    sheet.each_with_index do |row, index|
      next if index < 6
  
      # Extract data
      usn = row[1]&.to_s&.strip&.upcase 
      name = row[2]&.to_s&.strip&.upcase 
      c_no = row[3]&.to_s&.strip&.upcase 
  
      # Create or update student record
      student = Student.find_or_create_by!(usn: usn) do |student|
        student.name = name
        student.c_no = c_no
        student.section = Guide.find(session[:guide_id]).section
        student.batch_id = params[:batch_id]
      end

      student.update!(c_no: c_no) if student.c_no.blank?
      student.update!(batch_id: params[:batch_id]) if student.batch_id.blank?


    end
  
    redirect_to batch_path(params[:batch_id]), notice: "Students imported successfully!"

  end


  def index
    @batch = Batch.new
    @batches = Batch.all.order(created_at: :desc)
  end
  
  def create_two
    batch = Batch.new(batch_params)

    if batch.save
      @batches = Batch.all.order(created_at: :desc)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream:
          turbo_stream.update(
            "batches",
            partial: "shared/batches"
            )
          }
      end
    end
  end

  def edit
    puts "reach 1"
    @batch = Batch.find(params[:batch_id])
    puts "reach 2 #{@batch}"

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
        turbo_stream.update(
          "edit_batch#{@batch.id}",
          partial: "shared/edit_batch"
          ),
          locals: {batch: @batch}
      }
    end
  end

  def update
    puts "batch_ID: #{params[:batch][:id]}"

    @batch = Batch.find(params[:batch][:id])
    puts "batch: #{@batch}"
    @batches =Batch.all.order(created_at: :desc)

    if @batch.update(batch_params)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream:
          turbo_stream.update(
            "batches",
            partial: "shared/batches"
            )
          }
        end
    end

  end

  private

  def batch_params
    params.require(:batch).permit(:id, :name)
  end


end