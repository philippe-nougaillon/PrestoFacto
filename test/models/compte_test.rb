require 'test_helper'

class CompteTest < ActiveSupport::TestCase

    test "un compte a quelques champs obligatoires" do
        compte = Compte.new

        assert compte.invalid?
        assert compte.errors[:structure_id].any?
        assert compte.errors[:nom].any?
    end

end