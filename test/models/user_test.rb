require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "un user a quelques champs obligatoires" do
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?
    assert user.errors[:password].any?
    assert user.errors[:organisation].any?
  end

  test "l'user doit être créé s'il a des attributs valides" do
    user = users(:user_001)
    assert user.valid?
  end
  
end
