class Student < ApplicationRecord
  belongs_to :batch
  belongs_to :guide, optional: true
  
  has_many :projects
end
