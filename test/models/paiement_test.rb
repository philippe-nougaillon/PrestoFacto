require "test_helper"

class PaiementTest < ActiveSupport::TestCase

  test "un paiement a quelques champs obligatoires" do
    paiement = Paiement.new
    assert paiement.invalid?
    assert paiement.errors[:compte].any?
    assert paiement.errors[:date].any?
    assert paiement.errors[:montant].any?
  end

  test "un paiement doit couter au moins 0.01 €" do
		paiement = Paiement.new

		paiement.montant = 0
		assert paiement.invalid?
		assert_equal ["doit être supérieur ou égal à 0.01"], paiement.errors[:montant]
	end

  test "le paiement doit être créé s'il a des attributs valides" do
    paiement = paiements(:paiement)
    assert paiement.valid?
  end
  
end
