class FactureMailer < ApplicationMailer
    def envoyer_facture
        @facture = params[:facture]
        @email = params[:to]
        mail(to: @email,
             subject: "[#{@facture.organisation.nom}] Facture n° #{@facture.réf} disponible")
    end
end
