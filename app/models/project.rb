class Project < ApplicationRecord
  #belongs_to :student
  belongs_to :program

  has_many :students_project
  has_many :students, through: :students_project
end
