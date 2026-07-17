class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def ajout_prestations?
    user.admin?
  end

  def ajout_prestations_do?
    ajout_prestations?
  end

  def ajout_factures?
    user.admin?
  end

  def ajout_factures_do?
    ajout_factures?
  end

  def tarifs?
    user.admin?
  end

  def audit?
    user.admin?
  end

  def import?
    user.admin?
  end

  def import_do?
    import?
  end

  def exemple_fichier_import_xls?
    import?
  end

  def envoyer_factures?
    user.admin?
  end

  def envoyer_factures_do?
    envoyer_factures?
  end

  def dashboard?
    user && user.admin?
  end

  def stats?
    user && ['pierre-emmanuel.dacquet@aikku.eu', 'philippe.nougaillon@aikku.eu', 'philippe.nougaillon@gmail.com', 'sebastien.pourchaire@aikku.eu', 'serena.pinali@aikku.eu'].include?(user.email)
  end

end
