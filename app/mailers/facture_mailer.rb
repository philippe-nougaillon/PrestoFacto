class FactureMailer < ApplicationMailer
    def envoyer_facture
        @facture = params[:facture]
        @email = params[:to]
        mail(to: @email,
             subject: "[#{@facture.compte.organisation.nom}] Facture n° #{@facture.réf} disponible")
    end
end
