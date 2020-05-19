class TarifType < ApplicationRecord
  audited
  
  belongs_to :organisation
  
  has_many :tarifs
  has_many :enfants

  validates :nom, presence: true
  validates_uniqueness_of :nom, scope: [:organisation_id]
  
end
