class AddDebutFinToPrestationType < ActiveRecord::Migration[7.0]
  def change
    add_column :prestation_types, :debut, :string
    add_column :prestation_types, :fin, :string
    add_column :prestation_types, :pointage_arrivee, :boolean, default: true, null: false
  end
end
