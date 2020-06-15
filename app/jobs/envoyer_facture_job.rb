class EnvoyerFactureJob < ApplicationJob
  include SuckerPunch::Job

  def perform(f)

    email = f.compte.try(:contacts).first.try(:email)

    # Envoyer la facture
    FactureMailer.with(facture: f, to: email).envoyer_facture.deliver_later

    # Mise à jour de la date d'envoi
    f.update_attributes(envoyée_le: DateTime.now)
  end
end
