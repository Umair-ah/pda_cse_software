class AddTypeToGuide < ActiveRecord::Migration[7.0]
  def change
    add_column :guides, :section, :string
    add_column :guides, :type, :string
  end
end
