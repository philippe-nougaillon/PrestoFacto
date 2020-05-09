class PrestationType < ApplicationRecord
  audited
  
  belongs_to :organisation

  has_many :tarifs
  has_many :prestations

  validates :nom, presence: true
  validates_uniqueness_of :nom, scope: [:organisation_id]
end
