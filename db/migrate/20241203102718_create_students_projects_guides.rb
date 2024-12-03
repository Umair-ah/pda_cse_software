class CreateStudentsProjectsGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :students_projects_guides do |t|
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :project, null: false, foreign_key: true
      t.belongs_to :guide, null: false, foreign_key: true

      t.timestamps
    end
  end
end
