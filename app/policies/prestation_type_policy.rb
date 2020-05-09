class PrestationTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user.admin? && record.tarifs.count == 0 && record.prestations.count == 0
  end

end
