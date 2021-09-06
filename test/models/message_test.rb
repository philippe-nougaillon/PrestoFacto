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
    message = messages(:one)
    message.email = 'incorrect.com'

    message.valid?
    assert_equal ["n'est pas valide"], message.errors[:email]
  end

  test "le message doit être créé s'il a des attributs valides" do
    message = messages(:one)
    assert message.valid?
  end

end
