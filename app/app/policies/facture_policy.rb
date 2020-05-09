class FacturePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def edit?
    user.admin?
  end

  def to_xls?
    user.admin?
  end

end
