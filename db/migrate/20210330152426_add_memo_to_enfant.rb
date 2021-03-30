class AddMemoToEnfant < ActiveRecord::Migration[6.1]
  def change
    add_column :enfants, :mémo, :string
  end
end
