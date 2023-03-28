class FactureMessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def show?
    index? && (user.organisation == record.organisation)
  end

  def edit?
    index? && (user.organisation == record.organisation)
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
    index? && (user.organisation == record.organisation)
  end

end
