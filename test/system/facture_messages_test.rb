require "application_system_test_case"

class FactureMessagesTest < ApplicationSystemTestCase
  setup do
    @organisation = Organisation.create(nom: 'monoprix', email: 'monoprix@gmail.com' )
    @facture_message_actif = FactureMessage.create(contenu: 'bonjour', actif: true, organisation_id: @organisation.id)
    
    puts 'setup!!!!!!!!!!!'

    visit new_user_session_path
    sleep(1)
    click_on "Tout accepter"
    @user_001 = @organisation.users.create(email: 'toto@gmail.com', role: 'admin', password: '12345ZEIMFJ67U', password_confirmation: '12345ZEIMFJ67U', confirmed_at: DateTime.now)
    fill_in 'user_email', with: @user_001.email
    fill_in 'user_password', with: @user_001.password
    click_on 'Se connecter'
  end

  test "visiting the index" do
    visit facture_messages_url
    assert_selector "h2", text: "Messages"
  end

  test "creating a Facture message" do
    visit facture_messages_url
    click_on "Ajouter un message"

    # check "Actif"
    fill_in "facture_message_contenu", with: @facture_message_actif.contenu
    click_on "Enregistrer"

    assert_text "Message créé avec succès."
    # click_on "Voir"
  end

  test "updating a Facture message" do
    visit facture_message_path(@facture_message_actif)
    take_screenshot
    click_on "Editer", match: :first

    check "Actif"
    fill_in "Contenu", with: @facture_message_actif.contenu
    click_on "Enregistrer"

    assert_text "Message modifié avec succès."
  end

  # test "destroying a Facture message" do
  #   visit facture_messages_url
  #   page.accept_confirm do
  #     click_on "[X]", match: :first
  #   end

  #   assert_text "Message supprimé avec succès."
  # end
end