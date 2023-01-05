class StructurePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user.admin? && (user.organisation == record.organisation)
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def destroy?
    show? && record.classrooms.count == 0
  end
end
