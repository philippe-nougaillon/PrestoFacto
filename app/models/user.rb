class User < ApplicationRecord
  audited

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?


  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable and :omniauthable          
  #  :confirmable 

  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :validatable,
          :trackable, 
          :lockable


  belongs_to :organisation

  validates :email, presence: true

  self.per_page = 10

private
  def set_default_role
    self.role ||= :user
  end

  def admin? 
    self.role == 'admin'
  end

end
