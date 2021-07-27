require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "les attributs des messages doivent être non nuls" do
    message = Message.new
    assert message.invalid?
    assert message.errors[:email].any?
    assert message.errors[:objet].any?
    assert message.errors[:contenu].any?
  end

  test "l'adresse e-mail doit être correcte" do
    message = Message.new(email: 'incorect.com', objet: 'question', contenu: 'bonjour')

    message.invalid?
    assert_equal ["n'est pas valide"], message.errors[:email]

    message.email = 'corect@gmail.com'
    assert message.valid?
  end
end
