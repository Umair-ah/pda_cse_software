class StudentsProjectsGuide < ApplicationRecord
  belongs_to :student
  belongs_to :project
  belongs_to :guide
end
