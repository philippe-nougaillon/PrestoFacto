class OrganisationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    false
  end

  def show?
    user.admin? && (user.organisation == record)
  end

  def new?
    false
  end

  def create?
    new?
  end

  def edit?
    user.admin? && (user.organisation == record)
  end

  def update?
    edit?
  end

  def destroy?
    false
  end

  def suppression_organisation?
    user.admin? && (user.organisation == record)
  end

  def suppression_organisation_do?
    suppression_organisation? || ['pierre-emmanuel.dacquet@aikku.eu', 'philippe.nougaillon@aikku.eu', 'sebastien.pourchaire@aikku.eu'].include?(user.email)
  end

end
