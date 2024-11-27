class Guide < ApplicationRecord
  has_secure_password
  has_many :students
end
