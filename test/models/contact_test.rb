require "test_helper"

class ContactTest < ActiveSupport::TestCase

  test "un contact a quelques champs obligatoires" do
    contact = Contact.new
    assert contact.invalid?
    assert contact.errors[:compte].any?
  end

  test "le contact doit être créé s'il a des attributs valides" do
    contact = contacts(:contact)
    assert contact.valid?
  end
  
end
