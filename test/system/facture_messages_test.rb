require "application_system_test_case"

class FactureMessagesTest < ApplicationSystemTestCase

  setup do
    login_user
    @facture_message = facture_messages(:one)
  end

  test "visiting the index" do
    visit facture_messages_url
    assert_selector "h2", text: "Messages"
  end

  test "creating a Facture message" do
    visit facture_messages_url
    click_on "Ajouter un message"

    # check "Actif"
    fill_in "facture_message_contenu", with: @facture_message.contenu
    click_on "Enregistrer"

    assert_text "Message créé avec succès."
    # click_on "Voir"
  end

  test "updating a Facture message" do
    visit facture_message_path(@facture_message)
    # take_screenshot
    click_on "Editer", match: :first
    check "Actif"
    fill_in "Contenu", with: @facture_message.contenu
    click_on "Enregistrer"

    assert_text "Message modifié avec succès."
  end
end