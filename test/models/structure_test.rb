require 'test_helper'

class StructureTest < ActiveSupport::TestCase

    test "une structure a quelques champs obligatoires" do
        structure = Structure.new

        assert structure.invalid?
        assert structure.errors[:organisation_id].any?
        assert structure.errors[:nom].any?
    end

    test "la structure doit être créée si elle a des attributs valides" do
        sainteclotilde = structures(:sainteclotilde)
        assert sainteclotilde.valid?
    end

end