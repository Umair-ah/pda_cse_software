class CreateStudentsProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :students_projects do |t|
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
