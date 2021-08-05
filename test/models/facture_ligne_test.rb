require "test_helper"

class FactureLigneTest < ActiveSupport::TestCase
  
  test "une facture_ligne a quelques champs obligatoires" do
    facture_ligne = FactureLigne.new
    assert facture_ligne.invalid?
    assert facture_ligne.errors[:facture].any?
    assert facture_ligne.errors[:prestation_type].any?
  end

  test "la facture_ligne doit être créée si elle a des attributs valides" do
    facture_ligne = facture_lignes(:facture_ligne)
    assert facture_ligne.valid?
  end
  
end
