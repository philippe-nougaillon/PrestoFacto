class Reservation < ApplicationRecord
  audited
  
  belongs_to :enfant
  belongs_to :prestation_type

  scope :actives, ->{ where(active: true) }

  self.per_page = 10

end
