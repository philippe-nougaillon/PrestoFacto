require "application_system_test_case"

class EnfantsTest < ApplicationSystemTestCase

  setup do
    login_user
  end

  test "visiting the index" do
    visit enfants_url
    assert_selector "h2", text: "Enfants"
    sleep(10)
  end

  # test "changer plusieurs " do
    
  # end
end
