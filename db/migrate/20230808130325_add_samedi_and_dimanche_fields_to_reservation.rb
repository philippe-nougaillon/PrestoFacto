class AddSamediAndDimancheFieldsToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :samedi, :decimal, precision: 3, scale: 2, default: "0.0", null: false
    add_column :reservations, :dimanche, :decimal, precision: 3, scale: 2, default: "0.0", null: false
    
    Reservation.update_all(samedi: "0.0", dimanche: "0.0")
  end
end
