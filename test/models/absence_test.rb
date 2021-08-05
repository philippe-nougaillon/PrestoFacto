require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase

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
      @absence = Absence.create(enfant_id: thomas.id, début: Date.today, fin: Date.today)
    end

    test "une absence a quelques champs obligatoires" do
      absence = Absence.new
      assert absence.invalid?
      assert_equal ["doit exister"], absence.errors[:enfant]
      assert_equal ["doit être rempli(e)"], absence.errors[:début]
      assert_equal ["doit être rempli(e)"], absence.errors[:fin]
    end

    test "l'absence doit être créée si elle a des attributs valides" do
      puts @absence.errors.full_messages
      assert @absence.valid?
    end





end