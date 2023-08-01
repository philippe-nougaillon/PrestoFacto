class MessagePolicy < ApplicationPolicy
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
    false
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
    index? && (user.organisation == record.organisation)
  end

  def traiter?
    index? && (user.organisation == record.organisation)
  end

  def archiver?
    index? && (user.organisation == record.organisation)
  end
end
