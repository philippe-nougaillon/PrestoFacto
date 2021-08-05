require 'test_helper'

class CompteTest < ActiveSupport::TestCase

    test "un compte a quelques champs obligatoires" do
        compte = Compte.new
        assert compte.invalid?
        assert_equal ["doit exister"], compte.errors[:organisation]
        assert_equal ["doit être rempli(e)"], compte.errors[:nom]
    end

    test "le compte doit être créé s'il a des attributs valides" do
        compte_dupont = comptes(:dupont)
        assert compte_dupont.valid?
    end
end