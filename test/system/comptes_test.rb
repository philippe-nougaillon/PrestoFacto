require "application_system_test_case"

class ComptesTest < ApplicationSystemTestCase

  setup do
    login_user
  end

  test "Visiter l'index" do
    visit comptes_url
  
    assert_selector "h2", text: "Comptes"
  end

  test "Ajouter un compte" do
    visit comptes_url
    click_on "Compte"

    fill_in "compte_nom", with: comptes(:dupont).nom
    fill_in "compte_contacts_attributes_0_nom", with: contacts(:maman).nom
    fill_in "compte_contacts_attributes_0_email", with: contacts(:maman).email
    fill_in "compte_contacts_attributes_0_fixe", with: contacts(:maman).fixe
    fill_in "compte_contacts_attributes_0_portable", with: contacts(:maman).portable
    check "compte_contacts_attributes_0_prevenir"
    click_on "Enregistrer"

    assert_text "Compte créé avec succès."
  end

  test "Vérifier que le contact à prévenir est mis en évidence (couleur)" do
    visit compte_path(comptes(:dupont))
    assert_selector "tr", class: "alert-warning"
  end

  test "Rechercher un compte par son nom" do
    visit comptes_url

    fill_in "search", with: comptes(:dupont).nom
    assert_text "Affichage de 1 compte"
  end

  test "Rechercher un compte par le prénom de son enfant" do
    visit comptes_url

    fill_in "search", with: enfants(:thomas).prénom
    assert_text "Affichage de 1 compte"
  end

  test "export XLS" do
    visit comptes_url

    click_on "Export XLS"
    sleep(4)
    assert File.exists?( File.expand_path "~/Downloads/Comptes.xls" )
  end

  # TODO : modification test
    

  # test "modification" do
    
  # end

end
