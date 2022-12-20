class MailLogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user && user.admin?
  end

  def show?
    index?
  end
end
