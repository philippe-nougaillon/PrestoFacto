require 'test_helper'

class EnfantTest < ActiveSupport::TestCase

    test "un enfant a quelques champs obligatoires" do
        enfant = Enfant.new

        assert enfant.invalid?
        assert enfant.errors[:compte_id].any?
        assert enfant.errors[:classroom_id].any?
        assert enfant.errors[:tarif_type_id].any?
        assert enfant.errors[:nom].any?
        assert enfant.errors[:prénom].any?
        assert enfant.errors[:date_naissance].any?
    end
    
end