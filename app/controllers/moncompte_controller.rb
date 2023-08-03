class MoncompteController < ApplicationController

  def index
    # Vérifie que le compte est autorisé à se connecter
    @compte = Contact.find_by(email: current_user.email).compte
    authorize @compte

    # Prépare les totaux et les lignes du relevé de compte
    @total_factures = @compte.factures.sum(:montant)
    @total_paiements = @compte.paiements.sum(:montant)
    @solde = @total_paiements - @total_factures
    @releve = @compte.balance

    @enfants_count = @compte.enfants.count
    @réservations_count = @compte.reservations.count
    @factures_count = @compte.factures.count
    @absences_count = @compte.absences.count

    @total_alg = 0
    @total_sp = 0
  end

end
