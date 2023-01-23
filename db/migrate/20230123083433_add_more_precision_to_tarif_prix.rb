class AddMorePrecisionToTarifPrix < ActiveRecord::Migration[6.1]
  def self.up
    change_column :tarifs, :prix, :decimal, precision: 6, scale: 2
  end
end
