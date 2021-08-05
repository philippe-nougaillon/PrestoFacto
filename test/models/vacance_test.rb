require "test_helper"

class VacanceTest < ActiveSupport::TestCase
  
  test "une vacance a quelques champs obligatoires" do
    vacance = Vacance.new
    assert vacance.invalid?
    assert vacance.errors[:zone].any?
    assert vacance.errors[:nom].any?
    assert vacance.errors[:début].any?
    assert vacance.errors[:fin].any?
  end

  test "la vacance doit être créée si elle a des attributs valides" do
    jeanguile = vacances(:jeanguile)
    assert jeanguile.valid?
  end
  
end
