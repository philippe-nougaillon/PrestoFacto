class PointagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def show?
    false
  end

  def edit?
    index?
  end

  def update?
    edit?
  end

  def new?
    false
  end

  def create?
    new?
  end

  def destroy?
    index?
  end

end
