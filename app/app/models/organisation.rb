class Organisation < ApplicationRecord
    audited
    
    has_one_attached :logo

    has_many :structures, inverse_of: :organisation
    accepts_nested_attributes_for :structures, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

    has_many :users
    has_many :prestation_types, inverse_of: :organisation
    has_many :tarif_types
    has_many :facture_chronos
    has_many :comptes, through: :structures
    has_many :classrooms, through: :structures
    has_many :enfants, through: :comptes
    has_many :factures, through: :comptes
    has_many :paiements, through: :comptes 
    has_many :prestations, through: :enfants
    has_many :reservations, through: :enfants
    has_many :absences, through: :enfants
    has_many :tarifs, through: :tarif_types

    validates :nom, :email, presence: true
end
