class Presentation < ApplicationRecord
  belongs_to :student
  belongs_to :program

  has_many :points
end
