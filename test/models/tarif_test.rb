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

end