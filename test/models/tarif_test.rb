require 'test_helper'

class TarifTest < ActiveSupport::TestCase

    test "un tarif a quelques champs obligatoires" do
        tarif = Tarif.new

        assert tarif.invalid?
        assert tarif.errors[:tarif_type_id].any?
        assert tarif.errors[:prestation_type_id].any?
        assert tarif.errors[:prix].any?
    end

    test "un tarif doit couter au moins de 0.01 €" do
        tarif = Tarif.new

        tarif.prix = 0
        assert tarif.invalid?
        assert_equal ["doit être supérieur ou égal à 0.01"], tarif.errors[:prix]
    end

    test "un type de tarif de même nom doit être unique à chaque organisation" do
        organisation = Organisation.create(nom: 'TEST', email: 'toto@g.com')
        
        tarif_type = TarifType.create(organisation: organisation, nom: 'test unique')
        assert tarif_type.valid?

        prestation_type = PrestationType.create(organisation: organisation, nom: 'test unique')
        assert prestation_type.valid?

        tarif = Tarif.new(tarif_type: tarif_type, prestation_type: prestation_type, prix: 1)
        tarif.save

        assert tarif.valid?

        tarif_dupliqué = tarif.dup
        tarif_dupliqué.valid?

        assert_equal ["n'est pas disponible"], tarif_dupliqué.errors[:tarif_type_id]
    end

end