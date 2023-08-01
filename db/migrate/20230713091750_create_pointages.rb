class CreatePointages < ActiveRecord::Migration[7.0]
  def change
    create_table :pointages do |t|
      t.references :enfant, null: false, foreign_key: true
      t.references :prestation_type, null: false, foreign_key: true
      t.date :date_pointage
      t.datetime :heure_pointage

      t.timestamps
    end
  end
end
