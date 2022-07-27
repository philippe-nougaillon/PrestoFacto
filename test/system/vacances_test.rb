require "application_system_test_case"

class VacancesTest < ApplicationSystemTestCase
  setup do
    @vacance = vacances(:one)
  end

  test "visiting the index" do
    visit vacances_url
    assert_selector "h1", text: "Vacances"
  end

  test "creating a Vacance" do
    visit vacances_url
    click_on "New Vacance"

    fill_in "Début", with: @vacance.début
    fill_in "Fin", with: @vacance.fin
    fill_in "Nom", with: @vacance.nom
    fill_in "Organisation", with: @vacance.organisation_id
    fill_in "Zone", with: @vacance.zone
    click_on "Create Vacance"

    assert_text "Vacance was successfully created"
    click_on "Back"
  end

  test "updating a Vacance" do
    visit vacances_url
    click_on "Edit", match: :first

    fill_in "Début", with: @vacance.début
    fill_in "Fin", with: @vacance.fin
    fill_in "Nom", with: @vacance.nom
    fill_in "Organisation", with: @vacance.organisation_id
    fill_in "Zone", with: @vacance.zone
    click_on "Update Vacance"

    assert_text "Vacance was successfully updated"
    click_on "Back"
  end

  test "destroying a Vacance" do
    visit vacances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vacance was successfully destroyed"
  end
end
