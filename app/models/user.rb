class User < ApplicationRecord
  audited

  enum role: [:visiteur, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable and :omniauthable          
  #  :confirmable 

  devise  :database_authenticatable, 
          :recoverable, 
          :rememberable, 
          :validatable,
          :trackable, 
          :lockable,
          :confirmable,
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

private
  def set_default_role
    self.role ||= :visiteur
  end

  def after_confirmation
    UserMailer.with(user: self).welcome().deliver_now
  end

end
