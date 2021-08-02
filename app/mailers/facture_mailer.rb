class FactureMailer < ApplicationMailer
    def envoyer_facture
        @facture = params[:facture]
        @email = params[:to]
        mail(to: @email, subject: "[#{@facture.compte.organisation.nom}] Notification de facture")
    end
end
