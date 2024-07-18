# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_with_password
    UserMailer.with(user: Contact.last, password: SecureRandom.hex(10), organisation: User.first.organisation).welcome_with_password
  end

  def welcome
    UserMailer.with(user: User.last).welcome
  end
end
