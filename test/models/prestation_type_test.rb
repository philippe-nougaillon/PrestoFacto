require 'test_helper'

class PrestationTypeTest < ActiveSupport::TestCase

    test "un type de prestation a quelques champs obligatoires" do
        type_prestation = PrestationType.new

        assert type_prestation.invalid?
        assert type_prestation.errors[:organisation_id].any?
        assert type_prestation.errors[:nom].any?
    end

    test "un type de prestation de même nom doit être unique à chaque organisation" do
        organisation = Organisation.create(nom: 'TEST', email: 'toto@g.com')
        type_prestation = PrestationType.new(organisation: organisation, nom: 'test unique')
        type_prestation.save

        assert type_prestation.valid?

        type_prestation_dupliqué = type_prestation.dup
        type_prestation_dupliqué.valid?
        assert_equal ["n'est pas disponible"], type_prestation_dupliqué.errors[:nom]
    end

end