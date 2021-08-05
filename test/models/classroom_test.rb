require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase

    setup do
        monoprix = Organisation.create(nom: 'monoprix', email: 'monoprixgmail.com' )
        structure = Structure.create(nom: 'structure', organisation_id: monoprix.id)
        @cp = Classroom.create(nom: 'CP', structure_id: structure.id)
    end

    test "une classe a quelques champs obligatoires" do
        classroom = Classroom.new

        assert classroom.invalid?
        assert classroom.errors[:structure_id].any?
        assert classroom.errors[:nom].any?
    end

    test "la classe doit être créée si elle a des attributs valides" do
        assert @cp.valid?
    end

end