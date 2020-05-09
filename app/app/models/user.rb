class User < ApplicationRecord

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end


  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :validatable,
          :trackable, 
          :confirmable, 
          :lockable

  audited

  belongs_to :organisation

  validates :email, presence: true

  self.per_page = 10

end
