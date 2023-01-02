class ReservationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.vip_admin?
  end

  def update?
    index? && (user.organisation == record.organisation)
  end

  def destroy?
    edit?
  end

end
