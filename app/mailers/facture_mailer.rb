class FactureMailer < ApplicationMailer
    default from: 'nepasrepondre@prestofacto.net' 
    layout 'mailer'

    def envoyer_facture
        @facture = params[:facture]
        @email = params[:to]
        mail(to: @email, subject: "[#{@facture.compte.organisation.nom}] Notification de facture")
        puts "[MAILER OK] mail envoyé à #{@email}"
    end
end
