require "test_helper"

class VisiteurAdminPolicyTest < ActiveSupport::TestCase
  setup do
    @policy = AdminPolicy.new(users(:user_visiteur), :admin)
  end

  test "accès interdit pour un visiteur sur la facturation des prestations" do
    refute @policy.ajout_factures?
    refute @policy.ajout_factures_do?
  end
end
