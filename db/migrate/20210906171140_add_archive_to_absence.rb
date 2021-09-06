class AddArchiveToAbsence < ActiveRecord::Migration[6.1]
  def change
    add_column :absences, :archive, :boolean
    add_index :absences, :archive
  end
end
