require "application_system_test_case"

class PointagesTest < ApplicationSystemTestCase
  setup do
    @pointage = pointages(:one)
  end

  test "visiting the index" do
    visit pointages_url
    assert_selector "h1", text: "Pointages"
  end

  test "should create pointage" do
    visit pointages_url
    click_on "New pointage"

    fill_in "Date pointage", with: @pointage.date_pointage
    fill_in "Enfant", with: @pointage.enfant_id
    fill_in "Heure pointage", with: @pointage.heure_pointage
    fill_in "Prestation_type", with: @pointage.prestation_type_id
    click_on "Create Pointage"

    assert_text "Pointage was successfully created"
    click_on "Back"
  end

  test "should update Pointage" do
    visit pointage_url(@pointage)
    click_on "Edit this pointage", match: :first

    fill_in "Date pointage", with: @pointage.date_pointage
    fill_in "Enfant", with: @pointage.enfant_id
    fill_in "Heure pointage", with: @pointage.heure_pointage
    fill_in "Prestation_type", with: @pointage.prestation_type_id
    click_on "Update Pointage"

    assert_text "Pointage was successfully updated"
    click_on "Back"
  end

  test "should destroy Pointage" do
    visit pointage_url(@pointage)
    click_on "Destroy this pointage", match: :first

    assert_text "Pointage was successfully destroyed"
  end
end
