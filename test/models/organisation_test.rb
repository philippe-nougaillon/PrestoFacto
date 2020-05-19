require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase

    test "une organisation a un champs obligatoire" do
        organisation = Organisation.new

        assert organisation.invalid?
        assert organisation.errors[:nom].any?
        assert organisation.errors[:email].any?
    end
    
end