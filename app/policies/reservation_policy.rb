class ReservationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.vip_admin?
  end

  def edit?
    index? && (user.organisation == record.organisation)
  end

  def update?
    edit?
  end

  def new?
    user
  end

  def create?
    new?
  end

  def show?
    false
  end

  def destroy?
    edit?
  end

end
