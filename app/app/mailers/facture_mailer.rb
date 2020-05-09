class FactureMailer < ApplicationMailer
    default from: 'nepasrepondre@opencantine.net' 
    layout 'mailer'

    def envoyer_facture
        @facture = params[:facture]
        @email = params[:to]
        mail(to: @email, subject: "[#{@facture.compte.structure.organisation.nom}] Notification de facture (#{@facture.compte.structure.nom})")
        puts "[MAILER OK] mail envoyé à #{@email}"
    end
end
