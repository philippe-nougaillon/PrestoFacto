require 'test_helper'

class StructureTest < ActiveSupport::TestCase

    test "une structure a quelques champs obligatoires" do
        structure = Structure.new

        assert structure.invalid?
        assert structure.errors[:organisation_id].any?
        assert structure.errors[:nom].any?
    end

end