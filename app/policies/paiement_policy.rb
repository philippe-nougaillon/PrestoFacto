class PaiementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.vip_admin?
  end

  def show?
    index? && (user.organisation == record.organisation)
  end

  def edit?
    show?
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

  def destroy?
    show?
  end

  def to_xls?
    user.admin?
  end

end
