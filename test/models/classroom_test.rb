require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase
    
    test "une classe a quelques champs obligatoires" do
        classroom = Classroom.new

        assert classroom.invalid?
        assert classroom.errors[:structure_id].any?
        assert classroom.errors[:nom].any?
    end

    test "la classe doit être créée si elle a des attributs valides" do
        classroom = classrooms(:cp)
        assert classroom.valid?
    end

end