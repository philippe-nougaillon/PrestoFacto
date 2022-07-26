class AddDateToFactureLigne < ActiveRecord::Migration[6.1]
  def change
    add_column :facture_lignes, :date, :date
  end
end
