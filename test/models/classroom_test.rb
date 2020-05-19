require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase

    test "une classe a quelques champs obligatoires" do
        classroom = Classroom.new

        assert classroom.invalid?
        assert classroom.errors[:structure_id].any?
        assert classroom.errors[:nom].any?
    end

end