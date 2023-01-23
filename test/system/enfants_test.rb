require "application_system_test_case"

class EnfantsTest < ApplicationSystemTestCase

  setup do
    login_user
    @enfant_thomas = enfants(:thomas)
  end

  # test "visiting the index" do
  #   visit enfants_url
  #   assert_selector "h2", text: "Enfants"
  # end

  # test "changer plusieurs " do
    
  # end

  # test "Ajouter enfant" do
  #   visit compte_path(comptes(:dupont))

  #   click_on "Ajouter un enfant"    
  #   fill_in "enfant_nom", with: enfants(:thomas).nom
  #   fill_in "enfant_prénom", with: enfants(:thomas).prénom
  #   fill_in "enfant_nom", with: enfants(:thomas).nom
  #   select "Repas", from: "enfant_reservations_attributes_0_prestation_type_id" 
    
  #   assert_difference('Enfant.count') do
  #     click_on "Enregistrer"
  #   end
  # end

  #TODO : modification (compliqué)
  # test "Modification enfant" do
  #   visit enfant_path(@enfant_thomas)

  #   # sleep(3)
  #   # click_on "Éditer"
  #   # sleep(3)
  #   # fill_in "enfant_prénom", with: "toto"
  #   # click_on "Enregistrer"

  #   # assert_text "Enfant modifié avec succès."
  # end

  #TODO : export XLS

end
