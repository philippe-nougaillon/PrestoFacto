require "test_helper"

class FactureMessageTest < ActiveSupport::TestCase

  setup do
    @organisation = Organisation.create(nom: 'monoprix', email: 'monoprix@gmail.com' )
    @facture_message_actif = FactureMessage.create(contenu: 'bonjour', actif: true, organisation_id: @organisation.id)
  end

  test "les attributs des messages de factures doivent être non nuls" do
    facture_message = FactureMessage.new
    assert facture_message.invalid?
    assert facture_message.errors[:contenu].any?
    assert facture_message.errors[:organisation_id].any?
  end

  test "le message doit être créé s'il a des attributs valides" do
    assert @facture_message_actif.valid?
  end

  test "il ne doit y avoir qu'un seul message actif" do
    facture_message2 = @facture_message_actif.dup
    facture_message2.valid?
    assert_equal ["n'est pas disponible"], facture_message2.errors[:actif]
  end

end
