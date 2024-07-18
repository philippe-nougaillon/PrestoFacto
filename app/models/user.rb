class User < ApplicationRecord
  audited

  enum role: [:visiteur, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  validate :check_visiteur_email

  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable         

  devise  :database_authenticatable, 
          :recoverable, 
          :rememberable, 
          :validatable,
          :trackable, 
          # :lockable,
          # :confirmable,
          :registerable,
          :omniauthable,
          omniauth_providers: [:google_oauth2]
 
  belongs_to :organisation

  validates :email, presence: true

  def visiteur?
    self.role == 'visiteur'
  end

  def vip?
    self.role == 'vip'
  end

  def admin? 
    self.role == 'admin'
  end

  def vip_admin?
    self.vip? || self.admin?
  end

  def self.from_omniauth(auth)
    require "open-uri"

    if user = User.find_by(email: auth.info.email)
      user
    else
      find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
        
        #Crée l'organisation et ajoute le user dedans
        Organisation.create_from_signup(user, nil, nil, nil)
        
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
        
        user.save

        UserMailer.with(user: user).welcome.deliver_now
        UserMailer.with(user: user).new_account_notification().deliver_now
        
        user
      end
    end
  end

private
  def set_default_role
    self.role ||= :visiteur
  end

  def after_confirmation
    if self.admin?
      UserMailer.with(user: self).welcome().deliver_now
    end
  end

  def check_visiteur_email
    if self.visiteur? && Contact.find_by(email: self.email).nil?
      self.errors.add(:base, "L'adresse email d'un visiteur doit être celle d'un contact")
    else
      true
    end
  end

end
