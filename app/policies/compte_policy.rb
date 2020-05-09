class ComptePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def balance?
    user.admin?
  end

end
