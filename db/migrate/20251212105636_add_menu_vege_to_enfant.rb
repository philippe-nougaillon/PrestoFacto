class AddMenuVegeToEnfant < ActiveRecord::Migration[7.2]
  def change
    add_column :enfants, :menu_vege, :boolean, default: false
  end
end
