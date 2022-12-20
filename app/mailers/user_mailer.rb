class UserMailer < ApplicationMailer

  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: "Bienvenue !")
  end

  def new_account_notification
    @user = params[:user]
    mail(to:"philippe.nougaillon@gmail.com, p-edacquet@hotmail.fr")
  end
end
