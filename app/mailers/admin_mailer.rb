class AdminMailer < ApplicationMailer
  def suppression_organisation_notification
    @organisation = params[:organisation]
    @reason = params[:reason]
    mail(to: 'philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu', subject: "Un compte vient d'être supprimé")
  end
end
