require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase

    setup do
      @absence = Absence.create(enfant_id: @enfant_thomas.id, début: Date.today, fin: Date.today)
    end

    test "une absence a quelques champs obligatoires" do
      absence = Absence.new
      assert absence.invalid?
      assert_equal ["doit exister"], absence.errors[:enfant]
      assert_equal ["doit être rempli(e)"], absence.errors[:début]
      assert_equal ["doit être rempli(e)"], absence.errors[:fin]
    end

    test "l'absence doit être créée si elle a des attributs valides" do
      puts @absence.errors.full_messages
      assert @absence.valid?
    end





end