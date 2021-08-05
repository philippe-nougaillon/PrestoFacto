require "test_helper"

class FactureChronoTest < ActiveSupport::TestCase

  test "une facture_chrono a quelques champs obligatoires" do
    facture_chrono = FactureChrono.new
    assert facture_chrono.invalid?
    assert facture_chrono.errors[:organisation].any?
  end

  test "la facture_chrono doit être créée si elle a des attributs valides" do
    facture_chrono = facture_chronos(:facture_chrono)
    assert facture_chrono.valid?
  end
  
end
