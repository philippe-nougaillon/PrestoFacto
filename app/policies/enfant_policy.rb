class EnfantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def to_xls?
    user.admin?
  end
  
end
