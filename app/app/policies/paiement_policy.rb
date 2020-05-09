class PaiementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin?
  end

  def to_xls?
    user.admin?
  end

end
