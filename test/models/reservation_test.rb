require "test_helper"

class ReservationTest < ActiveSupport::TestCase

  test "une réservation a quelques champs obligatoires" do
      reservation = Reservation.new
      assert reservation.invalid?
      assert reservation.errors[:enfant].any?
      assert reservation.errors[:prestation_type].any?
  end

  test "la réservation doit être créée si elle a des attributs valides" do
    reservation_repas_thomas = reservations(:reservation_repas_thomas)
    assert reservation_repas_thomas.valid?
  end
end
