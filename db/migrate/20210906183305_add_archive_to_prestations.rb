class AddArchiveToPrestations < ActiveRecord::Migration[6.1]
  def change
    add_column :prestations, :archive, :boolean
    add_index :prestations, :archive
  end
end
