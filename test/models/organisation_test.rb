require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase

    test "une organisation a un champs obligatoire" do
        organisation = Organisation.new

        assert organisation.invalid?
        assert organisation.errors[:nom].any?
        assert organisation.errors[:email].any?
    end

    test "l'organisation doit être créée si elle a des attributs valides" do
        organisation = organisations(:monoprix)
        assert organisation.valid?
    end
    
end