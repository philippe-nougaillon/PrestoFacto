# Preview all emails at http://localhost:3000/rails/mailers/message_mailer
class MessageMailerPreview < ActionMailer::Preview
  def notification
    MessageMailer.with(message: Message.first).notification
  end
end
