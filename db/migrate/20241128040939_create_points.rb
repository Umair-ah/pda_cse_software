class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.string :guide_name
      t.string :student_name
      t.string :student_usn
      t.string :project_title
      t.decimal :mark1, scale: 1, precision: 3, default: 0
      t.decimal :mark2, scale: 1, precision: 3, default: 0
      t.decimal :mark3, scale: 1, precision: 3, default: 0
      t.decimal :mark4, scale: 1, precision: 3, default: 0
      t.decimal :mark5, scale: 1, precision: 3, default: 0
      t.decimal :total, scale: 1, precision: 3, default: 0
      t.boolean :locked, default: 0
      t.belongs_to :presentation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
