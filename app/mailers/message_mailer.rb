class MessageMailer < ApplicationMailer
  def notification_dev
    @message = params[:message]
    mail(to: 'philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu', subject: "Un nouveau message via 'Nous contacter' est arrivé")
  end
  def notification_organisation
    @message = params[:message]
    @admins_email = @message.organisation.users.where(role: "admin").pluck(:email)
    mail(to: @admins_email, subject: "Un nouveau message via 'Nous contacter' est arrivé")
  end
end
