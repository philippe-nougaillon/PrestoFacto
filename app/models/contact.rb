class Contact < ApplicationRecord
  audited
  
  belongs_to :compte, inverse_of: :contacts

  validates :nom, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

end
