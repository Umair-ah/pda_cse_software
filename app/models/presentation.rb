class Presentation < ApplicationRecord
  belongs_to :student
  belongs_to :program
  belongs_to :project


  has_many :points

  def update_total
    total = ((points.map(&:total).sum)/3)
    update_column(:grand_total, total)

    if self.program.name == "Mini"
      student.update_mini_marks
    else
      student.update_major_marks
    end
  end


  
end
