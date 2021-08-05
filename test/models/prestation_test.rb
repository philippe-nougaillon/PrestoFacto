require "test_helper"

class PrestationTest < ActiveSupport::TestCase

  test "une prestation a quelques champs obligatoires" do
    prestation = Prestation.new
    assert prestation.invalid?
    assert prestation.errors[:enfant].any?
    assert prestation.errors[:prestation_type].any?
    assert prestation.errors[:date].any?
  end

  test "la prestation doit être créée si elle a des attributs valides" do
    prestation = prestations(:prestation)
    assert prestation.valid?
  end
  
end
