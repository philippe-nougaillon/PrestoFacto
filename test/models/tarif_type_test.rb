require 'test_helper'

class TarifTypeTest < ActiveSupport::TestCase

    test "un type de tarif a un champs obligatoire" do
        tarif_type = TarifType.new

        assert tarif_type.invalid?
        assert tarif_type.errors[:nom].any?
    end
    
end