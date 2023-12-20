class User < ApplicationRecord
  audited

  enum role: [:visiteur, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  validate :check_visiteur_email

  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable and :omniauthable          

  devise  :database_authenticatable, 
          :recoverable, 
          :rememberable, 
          :validatable,
          :trackable, 
          # :lockable,
          # :confirmable,
          :registerable
 
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
