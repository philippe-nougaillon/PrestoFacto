class MoncompteController < ApplicationController
  def index
    
    @compte = Contact.find_by(email: current_user.email).compte

    authorize @compte
    
    @total_factures = @compte.factures.sum(:montant)
    @total_paiements = @compte.paiements.sum(:montant)
    @solde = @total_paiements - @total_factures
    
    @releve = @compte.balance

  end
end
