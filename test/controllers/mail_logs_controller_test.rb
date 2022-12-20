require "test_helper"

class MailLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mail_log = mail_logs(:one)
  end

  test "should get index" do
    get mail_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_mail_log_url
    assert_response :success
  end

  test "should create mail_log" do
    assert_difference('MailLog.count') do
      post mail_logs_url, params: { mail_log: { message_id: @mail_log.message_id, subject: @mail_log.subject, to: @mail_log.to } }
    end

    assert_redirected_to mail_log_url(MailLog.last)
  end

  test "should show mail_log" do
    get mail_log_url(@mail_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_mail_log_url(@mail_log)
    assert_response :success
  end

  test "should update mail_log" do
    patch mail_log_url(@mail_log), params: { mail_log: { message_id: @mail_log.message_id, subject: @mail_log.subject, to: @mail_log.to } }
    assert_redirected_to mail_log_url(@mail_log)
  end

  test "should destroy mail_log" do
    assert_difference('MailLog.count', -1) do
      delete mail_log_url(@mail_log)
    end

    assert_redirected_to mail_logs_url
  end
end
