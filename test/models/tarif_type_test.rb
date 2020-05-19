require 'test_helper'

class TarifTypeTest < ActiveSupport::TestCase

    test "un type de tarif a un champs obligatoire" do
        tarif_type = TarifType.new

        assert tarif_type.invalid?
        assert tarif_type.errors[:nom].any?
    end

    test "un type de tarif de même nom doit être unique à chaque organisation" do
        organisation = Organisation.create(nom: 'TEST', email: 'toto@g.com')
        tarif_type = TarifType.new(organisation: organisation, nom: 'test unique')
        tarif_type.save

        assert tarif_type.valid?

        tarif_type_dupliqué = tarif_type.dup
        tarif_type_dupliqué.valid?
        assert_equal ["n'est pas disponible"], tarif_type_dupliqué.errors[:nom]
    end
    
end