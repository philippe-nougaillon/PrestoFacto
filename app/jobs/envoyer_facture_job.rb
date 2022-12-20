class EnvoyerFactureJob < ApplicationJob
  include SuckerPunch::Job

  def perform(f, current_user)

    email = f.compte.try(:contacts).first.try(:email)

    # Envoyer la facture
    mailer_response = FactureMailer.with(facture: f, to: email).envoyer_facture.deliver_now
    MailLog.create(organisation_id: current_user.organisation.id, message_id:mailer_response.message_id, to:email, subject: "Facture")

    # Mise à jour de la date d'envoi
    f.update(envoyée_le: DateTime.now)
  end
end
