class MessageMailer < ApplicationMailer
  def notification
    @message = params[:message]
    mail(to: 'prestofacto@philnoug.com', subject: "Un nouveau message via 'Nous contacter' est arrivé")
  end
end
