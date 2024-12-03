class Guide < ApplicationRecord
  has_secure_password
  #has_many :students
  #has_many :projects, through: :students

  has_many :students_projects_guides
  has_many :students, through: :students_projects_guides
  has_many :projects, through: :students_projects_guides 
end
