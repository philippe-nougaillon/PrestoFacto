require "test_helper"

class VipAdminPolicyTest < ActiveSupport::TestCase
  setup do
    @policy = AdminPolicy.new(users(:user_vip), :admin)
  end

  test "accès interdit pour un vip sur la facturation des prestations" do
    refute @policy.ajout_factures?
    refute @policy.ajout_factures_do?
  end
end
