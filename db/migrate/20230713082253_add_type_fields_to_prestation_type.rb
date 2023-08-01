class AddTypeFieldsToPrestationType < ActiveRecord::Migration[7.0]
  def change
    add_column :prestation_types, :forfaitaire, :boolean, default: true, null: false
    add_column :prestation_types, :duree_tranche, :integer, default: 0
    PrestationType.update_all(forfaitaire: true, duree_tranche: 0)
  end
end
