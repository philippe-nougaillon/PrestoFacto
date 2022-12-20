class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user && user.email == "philippe.nougaillon@gmail.com"
  end

  def show?
    index?
  end

  def edit?
    index?
  end

  def update?
    edit?
  end

  def new?
    true
  end

  def create?
    new?
  end

  def destroy?
    index?
  end
end
