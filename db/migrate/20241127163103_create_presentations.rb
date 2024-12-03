class CreatePresentations < ActiveRecord::Migration[7.0]
  def change
    create_table :presentations do |t|
      t.string :name
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :program, null: false, foreign_key: true
      t.belongs_to :project, null: false, foreign_key: true

      t.decimal :grand_total, scale: 1, precision: 3, default: 0


      t.timestamps
    end
  end
end
