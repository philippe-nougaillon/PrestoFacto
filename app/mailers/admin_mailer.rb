class AdminMailer < ApplicationMailer
  def suppression_organisation_notification
    @organisation = params[:organisation]
    @reason = params[:reason]
    mail(to: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com', subject: "Un compte vient d'être supprimé")
  end
end
