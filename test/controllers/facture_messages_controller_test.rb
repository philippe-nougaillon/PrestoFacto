require "test_helper"

class FactureMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @organisation = Organisation.create(nom: 'monoprix', email: 'monoprix@gmail.com' )
    @facture_message_actif = FactureMessage.create(contenu: 'bonjour', actif: true, organisation_id: @organisation.id)
    get new_user_session_path
    @user_001 = @organisation.users.create(email: 'toto@gmail.com', role: 'admin', password: '12345ZEIMFJ67U', password_confirmation: '12345ZEIMFJ67U')
    sign_in @user_001
    # puts @user_001.inspect
    # puts @user_001.valid?
    # puts @user_001.errors.messages
  end

  # test "should log in" do
  #   assert_response :success
  # end

  # test "should get index" do
  #   get facture_messages_url
  #   assert_redirected_to facture_messages_url
  # end

  # test "should get new" do
  #   get new_facture_message_url
  #   assert_response :success
  # end

  # test "should create facture_message" do
  #   assert_difference('FactureMessage.count') do
  #     post facture_messages_url, params: { facture_message: { actif: @facture_message.actif, contenu: @facture_message.contenu } }
  #   end

  #   assert_redirected_to facture_message_url(FactureMessage.last)
  # end

  # test "should show facture_message" do
  #   get facture_message_url(@facture_message)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_facture_message_url(@facture_message)
  #   assert_response :success
  # end

  # test "should update facture_message" do
  #   patch facture_message_url(@facture_message), params: { facture_message: { actif: @facture_message.actif, contenu: @facture_message.contenu } }
  #   assert_redirected_to facture_message_url(@facture_message)
  # end

  # test "should destroy facture_message" do
  #   assert_difference('FactureMessage.count', -1) do
  #     delete facture_message_url(@facture_message)
  #   end

  #   assert_redirected_to facture_messages_url
  # end
end
