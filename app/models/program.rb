class Program < ApplicationRecord
  has_many :projects
  has_many :presentations
end
