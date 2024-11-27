class Project < ApplicationRecord
  belongs_to :student
  belongs_to :program
end
