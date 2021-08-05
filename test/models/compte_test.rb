require 'test_helper'

class CompteTest < ActiveSupport::TestCase

    setup do
        organisation = Organisation.create(nom: 'monoprix', email: 'monoprix@gmail.com' )
        @dupont = Compte.create(organisation_id: organisation.id, nom: 'Dupont')
    end

    test "un compte a quelques champs obligatoires" do
        compte = Compte.new
        assert compte.invalid?
        assert_equal ["doit exister"], compte.errors[:organisation]
        assert_equal ["doit être rempli(e)"], compte.errors[:nom]
    end

    test "le compte doit être créé s'il a des attributs valides" do
        assert @dupont.valid?
    end





end