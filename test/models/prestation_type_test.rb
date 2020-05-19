require 'test_helper'

class PrestationTypeTest < ActiveSupport::TestCase

    test "un type de prestation a quelques champs obligatoires" do
        type_prestation = PrestationType.new

        assert type_prestation.invalid?
        assert type_prestation.errors[:organisation_id].any?
        assert type_prestation.errors[:nom].any?
    end

end