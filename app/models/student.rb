class Student < ApplicationRecord
  belongs_to :batch
  belongs_to :guide, optional: true

  has_many :presentations

  has_one :students_project
  has_one :project, through: :students_project

  after_update :change_to_capital

  def change_to_capital
    update_column(:usn, self.usn&.to_s&.strip&.upcase)
    update_column(:name, self.name&.to_s&.strip&.upcase)
    update_column(:section, self.section&.to_s&.strip&.upcase)
  end

  #student.presentations.joins(:program).where(program: {id: params[:program_id]})

  def update_mini_marks
    total_mini_marks_of_both_presentations = presentations.joins(:program).where(program: {name: "Mini"}).map(&:grand_total).sum
    final_mini_marks = (total_mini_marks_of_both_presentations/2)
    update_column(:mini_marks, final_mini_marks.ceil)
  end

  def update_major_marks
    total_major_marks_of_both_presentations = presentations.joins(:program).where(program: {name: "Major"}).map(&:grand_total).sum
    final_major_marks = (total_major_marks_of_both_presentations/2)
    update_column(:major_marks, final_major_marks.ceil)
  end

end
