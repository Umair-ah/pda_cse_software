class Presentation < ApplicationRecord
  belongs_to :student

  has_many :points
end
