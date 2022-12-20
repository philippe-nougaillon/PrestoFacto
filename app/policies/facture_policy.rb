class FacturePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.vip_admin?
  end

  def action?
    index?
  end

  def show?
    true
  end

  def edit?
    index? && (user.organisation == record.organisation)
  end

  def update?
    edit?
  end

  def new?
    index?
  end

  def create?
    new?
  end

  def to_xls?
    index?
  end

  def destroy?
    edit?
  end

end
