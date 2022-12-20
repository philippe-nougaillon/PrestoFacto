class MessageMailer < ApplicationMailer
  def notification
    @message = params[:message]
    mail(to: 'philippe.nougaillon@gmail.com', subject: "Un nouveau message via 'Nous contacter' est arrivé")
  end
end
