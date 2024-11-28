class Project < ApplicationRecord
  #belongs_to :student
  belongs_to :program
  belongs_to :batch
  belongs_to :guide


  has_many :students_project
  has_many :students, through: :students_project
end
