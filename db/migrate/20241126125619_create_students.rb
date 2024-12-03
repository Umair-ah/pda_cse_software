class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :usn
      t.string :name
      t.string :section
      t.string :c_no
      t.decimal :mini_marks, scale: 1, precision: 3, default: 0
      t.decimal :major_marks, scale: 1, precision: 3, default: 0

      t.timestamps
    end
  end
end
