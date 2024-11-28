class Batch < ApplicationRecord
  has_many :students
  has_many :projects
end
