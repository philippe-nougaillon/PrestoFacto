require "test_helper"

class VacancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vacance = vacances(:one)
  end

  test "should get index" do
    get vacances_url
    assert_response :success
  end

  test "should get new" do
    get new_vacance_url
    assert_response :success
  end

  test "should create vacance" do
    assert_difference('Vacance.count') do
      post vacances_url, params: { vacance: { début: @vacance.début, fin: @vacance.fin, nom: @vacance.nom, organisation_id: @vacance.organisation_id, zone: @vacance.zone } }
    end

    assert_redirected_to vacance_url(Vacance.last)
  end

  test "should show vacance" do
    get vacance_url(@vacance)
    assert_response :success
  end

  test "should get edit" do
    get edit_vacance_url(@vacance)
    assert_response :success
  end

  test "should update vacance" do
    patch vacance_url(@vacance), params: { vacance: { début: @vacance.début, fin: @vacance.fin, nom: @vacance.nom, organisation_id: @vacance.organisation_id, zone: @vacance.zone } }
    assert_redirected_to vacance_url(@vacance)
  end

  test "should destroy vacance" do
    assert_difference('Vacance.count', -1) do
      delete vacance_url(@vacance)
    end

    assert_redirected_to vacances_url
  end
end
