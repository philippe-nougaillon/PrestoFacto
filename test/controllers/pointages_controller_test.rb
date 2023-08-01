require "test_helper"

class PointagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pointage = pointages(:one)
  end

  test "should get index" do
    get pointages_url
    assert_response :success
  end

  test "should get new" do
    get new_pointage_url
    assert_response :success
  end

  test "should create pointage" do
    assert_difference("Pointage.count") do
      post pointages_url, params: { pointage: { date_pointage: @pointage.date_pointage, enfant_id: @pointage.enfant_id, heure_pointage: @pointage.heure_pointage, prestation_type_id: @pointage.prestation_type_id } }
    end

    assert_redirected_to pointage_url(Pointage.last)
  end

  test "should show pointage" do
    get pointage_url(@pointage)
    assert_response :success
  end

  test "should get edit" do
    get edit_pointage_url(@pointage)
    assert_response :success
  end

  test "should update pointage" do
    patch pointage_url(@pointage), params: { pointage: { date_pointage: @pointage.date_pointage, enfant_id: @pointage.enfant_id, heure_pointage: @pointage.heure_pointage, prestation_type_id: @pointage.prestation_type_id } }
    assert_redirected_to pointage_url(@pointage)
  end

  test "should destroy pointage" do
    assert_difference("Pointage.count", -1) do
      delete pointage_url(@pointage)
    end

    assert_redirected_to pointages_url
  end
end
