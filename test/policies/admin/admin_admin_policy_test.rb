require "test_helper"

class AdminAdminPolicyTest < ActiveSupport::TestCase
  setup do
    @policy = AdminPolicy.new(users(:user_001), :admin)
  end

  test "accès autorisé pour un administrateur sur la facturation des prestations" do
    assert @policy.ajout_factures?
    assert @policy.ajout_factures_do?
  end
end
