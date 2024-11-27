class BatchesController < ApplicationController

  def show_two; end

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
        student.guide = guide
        student.batch_id = params[:batch_id]
      end
  
      # Update student guide if it's blank (although the creation ensures it's set)
      student.update!(guide: guide) if student.guide.blank?
  
      # Ensure project exists or is created for the student
      Project.find_or_create_by!(usn: student.usn, title: current_project_title) do |project|
        project.student = student
        project.program = program
      end
    end
  end
  
  

  def show
    @students = Student.all.order(:usn)
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
      usn = row[2]&.to_s&.strip&.upcase # Column 'D'
      name = row[3]&.to_s&.strip&.upcase # Column 'E'
      c_no = row[4]&.to_s&.strip&.upcase # Column 'F'
  
      # Create or update student record
      Student.find_or_create_by!(usn: usn) do |student|
        student.name = name
        student.c_no = c_no
        student.batch_id = params[:batch_id]
      end
    end
  
    redirect_to batch_path(params[:batch_id]), notice: "Students imported successfully!"

  end


  def index
    @batch = Batch.new
    @batches = Batch.all.order(created_at: :desc)
  end
  
  def create
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
    @batch = Batch.find(params[:batch_id])
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