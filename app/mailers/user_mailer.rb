class UserMailer < ApplicationMailer

  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: "Bienvenue #{ @user.email.split('@').first}!")
  end

  def welcome_with_password
    @user = params[:user]
    @password = params[:password]
    @organisation = params[:organisation]
    mail(to: @user.email, subject: "Bienvenue #{ @user.email.split('@').first} !")
  end

  def new_account_notification
    @user = params[:user]
    mail(to:"philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com")
  end
end
