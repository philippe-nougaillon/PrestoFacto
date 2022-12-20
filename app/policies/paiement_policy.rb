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
    index?
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

  def destroy?
    edit?
  end

  def to_xls?
    user.admin?
  end

end
