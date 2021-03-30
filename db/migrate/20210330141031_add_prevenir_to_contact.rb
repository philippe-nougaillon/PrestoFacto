class AddPrevenirToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :prevenir, :boolean
  end
end
