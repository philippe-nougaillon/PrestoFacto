class TarifTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    user.admin? && (user.organisation == record.organisation)
  end

  def update?
    edit?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def destroy?
    edit? && record.tarifs.count == 0 && record.enfants.count == 0
  end

end
