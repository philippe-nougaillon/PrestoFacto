class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    false
  end

  def destroy?
    # empêcher l'admin de se détruire lui-même !
    record != user
  end

end
