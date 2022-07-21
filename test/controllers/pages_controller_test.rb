require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get accueil" do
    get pages_accueil_url
    assert_response :success
  end
end
