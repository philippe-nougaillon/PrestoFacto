class Tarif < ApplicationRecord
  audited
  
  belongs_to :tarif_type
  belongs_to :prestation_type

  validates :tarif_type_id, :prestation_type_id, :prix, presence: true
  validates_uniqueness_of :tarif_type_id, scope: [:prestation_type_id]

  validates :prix, numericality: { greater_than_or_equal_to: 0.01 }

end
