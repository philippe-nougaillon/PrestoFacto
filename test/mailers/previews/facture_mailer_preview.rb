# Preview all emails at http://localhost:3000/rails/mailers/facture_mailer
class FactureMailerPreview < ActionMailer::Preview
  def envoyer_facture
    FactureMailer.with(email: User.first.email, facture: Facture.last ).envoyer_facture
  end
end
