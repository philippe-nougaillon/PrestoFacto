class Absence < ApplicationRecord
  audited
  
  belongs_to :enfant

  validates :début, :fin, presence: true

  has_one :organisation, through: :enfant


  # self.per_page = 10

end
