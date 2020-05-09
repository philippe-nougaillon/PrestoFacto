class Tarif < ApplicationRecord
  audited
  
  belongs_to :tarif_type
  belongs_to :prestation_type

  validates_uniqueness_of :tarif_type_id, scope: [:prestation_type_id]
end
