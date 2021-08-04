class CreateFactureMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :facture_messages do |t|
      t.string :contenu
      t.boolean :actif

      t.timestamps
    end
  end
end
