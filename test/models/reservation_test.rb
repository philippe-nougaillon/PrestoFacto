require "test_helper"

class ReservationTest < ActiveSupport::TestCase

  setup do
    monoprix = Organisation.create(nom: 'monoprix', email: 'monoprixgmail.com' )
    cantine = TarifType.create(nom: 'cantine', organisation_id: monoprix.id)
    structure = Structure.create(nom: 'structure', organisation_id: monoprix.id)
    cp = Classroom.create(nom: 'CP', structure_id: structure.id)
    dupont = Compte.create(organisation_id: monoprix.id, nom: 'Dupont')
    thomas = Enfant.create(
        nom: 'Dupont',
        prénom: 'Thomas',
        tarif_type_id: cantine.id,
        classroom_id: cp.id,
        compte_id: dupont.id)
    prestation_type = PrestationType.create(nom: 'prestation_type', organisation_id: monoprix.id)
    @reservation = Reservation.create(enfant_id: thomas.id, prestation_type_id: prestation_type.id, début: Date.today, fin: Date.today + 1.day)
  end

  test "une réservation a quelques champs obligatoires" do
      reservation = Reservation.new
      puts reservation.errors.full_messages
      assert reservation.invalid?
  end

  test "la réservation doit être créée si elle a des attributs valides" do
    assert @reservation.valid?
  end
end
