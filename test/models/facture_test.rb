require "test_helper"

class FactureTest < ActiveSupport::TestCase
  
  test "les attributs des factures doivent être non nuls" do
    facture = Facture.new
    assert facture.invalid?
    assert facture.errors[:compte].any?
    assert facture.errors[:réf].any?
  end

  test "la facture doit être créée si elle a des attributs valides" do
    facture = factures(:one)
    assert facture.valid?
  end
  
end
