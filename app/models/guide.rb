class Guide < ApplicationRecord
  has_secure_password
  has_many :students
  has_many :projects, through: :students
end
