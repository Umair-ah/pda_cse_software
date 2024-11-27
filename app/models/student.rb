class Student < ApplicationRecord
  belongs_to :batch
  belongs_to :guide, optional: true

  has_many :presentations

  has_one :students_project
  has_one :project, through: :students_project
end
