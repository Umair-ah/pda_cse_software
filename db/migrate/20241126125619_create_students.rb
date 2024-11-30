class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :usn
      t.string :name
      t.string :section
      t.string :c_no
      t.belongs_to :guide, foreign_key: true

      t.timestamps
    end
  end
end
