class AddSoldeToFacture < ActiveRecord::Migration[6.1]
  def change
    add_column :factures, :solde_avant, :decimal, precision: 8, scale: 2
    add_column :factures, :solde_après, :decimal, precision: 8, scale: 2
  end
end
