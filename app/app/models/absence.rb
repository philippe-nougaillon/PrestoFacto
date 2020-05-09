class Absence < ApplicationRecord
  audited
  
  belongs_to :enfant

  has_one :organisation, through: :enfant


  self.per_page = 10

end
