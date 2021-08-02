class ComptePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def balance?
    user.admin?
  end

  def to_xls?
    user.admin?
  end

end
