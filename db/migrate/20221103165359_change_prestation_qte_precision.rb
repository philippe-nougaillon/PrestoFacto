class ChangePrestationQtePrecision < ActiveRecord::Migration[6.1]
  def change
    change_column :prestations, :qté, :decimal, precision: 5, scale: 2, default: "0.0", null: false
  end
end
