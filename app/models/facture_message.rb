class FactureMessage < ApplicationRecord
  belongs_to :organisation

  validates :contenu, :organisation_id, presence: true
  validates_uniqueness_of :actif, scope: :organisation_id, conditions: -> {where(actif: true)}

  scope :actif, -> { where(actif: true) }
end
