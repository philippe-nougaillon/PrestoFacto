class PrestationTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    new? && (user.organisation == record.organisation)
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? && record.tarifs.count == 0 && record.prestations.count == 0 && record.reservations.count == 0
  end

end
