class Prestation < ApplicationRecord
  audited
  
  belongs_to :enfant
  belongs_to :prestation_type

  validates :enfant_id, :prestation_type_id, :date, presence: true
  validates_uniqueness_of :enfant_id, scope: [:date, :prestation_type_id], message: "Il existe déjà une prestation pour cet enfant et ce jour)"

  default_scope { where(archive: false) }
  # default_scope { order(:date, :prestation_type_id) }
  
  scope :à_facturer, -> { where(facture_id: nil) }

end
