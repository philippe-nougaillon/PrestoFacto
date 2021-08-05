require "test_helper"

class FactureMessageTest < ActiveSupport::TestCase

  test "les attributs des messages de factures doivent être non nuls" do
    facture_message = FactureMessage.new
    assert facture_message.invalid?
    assert facture_message.errors[:contenu].any?
    assert facture_message.errors[:organisation_id].any?
  end

  test "le message doit être créé s'il a des attributs valides" do
    facture_message = facture_messages(:one)
    assert facture_message.valid?
  end

  test "il ne doit y avoir qu'un seul message actif" do
    facture_message = facture_messages(:one).dup
    facture_message.valid?
    assert_equal ["n'est pas disponible"], facture_message.errors[:actif]
  end

end
