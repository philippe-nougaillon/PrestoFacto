require 'test_helper'

class EnfantTest < ActiveSupport::TestCase

    setup do
        monoprix = Organisation.create(nom: 'monoprix', email: 'monoprixgmail.com' )
        cantine = TarifType.create(nom: 'cantine', organisation_id: monoprix.id)
        structure = Structure.create(nom: 'structure', organisation_id: monoprix.id)
        cp = Classroom.create(nom: 'CP', structure_id: structure.id)
        dupont = Compte.create(organisation_id: monoprix.id, nom: 'Dupont')
        @thomas = Enfant.create(
            nom: 'Dupont',
            prénom: 'Thomas',
            tarif_type_id: cantine.id,
            classroom_id: cp.id,
            compte_id: dupont.id)
    end

    test "un enfant a quelques champs obligatoires" do
        enfant = Enfant.new

        assert enfant.invalid?
        assert enfant.errors[:compte_id].any?
        assert enfant.errors[:classroom_id].any?
        assert enfant.errors[:tarif_type_id].any?
        assert enfant.errors[:nom].any?
        assert enfant.errors[:prénom].any?
    end

    test "l'enfant doit être créé s'il a des attributs valides" do
        assert @thomas.valid?
    end
    
end