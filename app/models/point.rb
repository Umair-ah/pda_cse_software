class Point < ApplicationRecord
  belongs_to :presentation
  validates :mark1, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, 
    message: "should be between 0 and 5" }

  validates :mark2, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, 
    message: "should be between 0 and 10" }

  validates :mark3, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, 
    message: "should be between 0 and 10" }

  validates :mark4, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 20, 
    message: "should be between 0 and 20" }

  validates :mark5, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, 
    message: "should be between 0 and 5" }


  after_update :lock_form, :calc_tot

  def lock_form
    self.locked = true
    save if saved_changes?
  end

  def calc_tot
    tot = (self.mark1 + self.mark2 + self.mark3 + self.mark4 + self.mark5)
    update_column(:total, tot)
  end
end
