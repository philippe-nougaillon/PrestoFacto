require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase

    test "une absence a quelques champs obligatoires" do
      absence = Absence.new
      assert absence.invalid?
      assert_equal ["doit exister"], absence.errors[:enfant]
      assert_equal ["doit être rempli(e)"], absence.errors[:début]
      assert_equal ["doit être rempli(e)"], absence.errors[:fin]
    end

    test "l'absence doit être créée si elle a des attributs valides" do
      absence_thomas = absences(:absence_thomas)
      assert absence_thomas.valid?
    end





end