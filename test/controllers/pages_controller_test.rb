require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get pages_welcome_url
    assert_response :success
  end
end
