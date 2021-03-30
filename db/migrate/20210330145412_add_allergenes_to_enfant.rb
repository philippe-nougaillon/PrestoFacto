class AddAllergenesToEnfant < ActiveRecord::Migration[6.1]
  def change
    add_column :enfants, :allergenes, :string
  end
end
