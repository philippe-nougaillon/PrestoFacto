class PrestationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.vip_admin?
  end

  def show?
    index? && (user.organisation == record.enfant.organisation)
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
    edit?
  end
end
