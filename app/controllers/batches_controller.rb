class BatchesController < ApplicationController

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
      usn = row[2].to_s.strip.upcase # Column 'D'
      name = row[3].to_s.strip.upcase # Column 'E'
      c_no = row[4].to_s.strip.upcase # Column 'F'
  
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