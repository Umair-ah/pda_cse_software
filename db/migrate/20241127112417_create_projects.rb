class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :usn
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :program, null: false, foreign_key: true

      t.timestamps
    end
  end
end
