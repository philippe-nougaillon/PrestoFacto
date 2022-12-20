require "application_system_test_case"

class MailLogsTest < ApplicationSystemTestCase
  setup do
    @mail_log = mail_logs(:one)
  end

  test "visiting the index" do
    visit mail_logs_url
    assert_selector "h1", text: "Mail Logs"
  end

  test "creating a Mail log" do
    visit mail_logs_url
    click_on "New Mail Log"

    fill_in "Message", with: @mail_log.message_id
    fill_in "Subject", with: @mail_log.subject
    fill_in "To", with: @mail_log.to
    click_on "Create Mail log"

    assert_text "Mail log was successfully created"
    click_on "Back"
  end

  test "updating a Mail log" do
    visit mail_logs_url
    click_on "Edit", match: :first

    fill_in "Message", with: @mail_log.message_id
    fill_in "Subject", with: @mail_log.subject
    fill_in "To", with: @mail_log.to
    click_on "Update Mail log"

    assert_text "Mail log was successfully updated"
    click_on "Back"
  end

  test "destroying a Mail log" do
    visit mail_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mail log was successfully destroyed"
  end
end
