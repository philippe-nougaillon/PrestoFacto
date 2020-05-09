class TarifTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user.admin? && record.tarifs.count == 0 && record.enfants.count == 0
  end

end
