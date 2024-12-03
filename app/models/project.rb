class Project < ApplicationRecord
  #belongs_to :student
  belongs_to :program
  belongs_to :batch
  #belongs_to :guide

  has_many :presentations


  has_many :students_projects_guides
  has_many :students, through: :students_projects_guides
  has_many :guides, through: :students_projects_guides
end
