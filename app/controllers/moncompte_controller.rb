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
  end

end
