class Organisation < ApplicationRecord
    audited
    
    has_one_attached :logo

    has_many :structures, inverse_of: :organisation
    accepts_nested_attributes_for :structures, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

    has_many :users
    has_many :comptes

    has_many :prestation_types, inverse_of: :organisation
    has_many :tarif_types
    has_many :facture_chronos
    has_many :classrooms, through: :structures
    has_many :enfants, through: :classrooms
    has_many :factures, through: :comptes
    has_many :paiements, through: :comptes 
    has_many :prestations, through: :enfants
    has_many :reservations, through: :enfants
    has_many :absences, through: :enfants
    has_many :tarifs, through: :tarif_types

    validates :nom, :email, presence: true


    def self.create_from_signup(user, organisation, structure)
        # On crée l'organisation 
        organisation = Organisation.create( nom: organisation, 
                                            email: user.email, 
                                            zone: 'A')

        organisation.structures.create(nom: structure)

        # et quelques données de base pour aider la prise en main 
        organisation.structures.first.classrooms.create(nom: 'UNE CLASSE')
        organisation.comptes.create(nom: 'FAMILLE-TEST')
        organisation.facture_chronos.create(index: 1)
        organisation.tarif_types.create(nom: 'Général')
        organisation.prestation_types.create(nom: 'Repas')
        organisation.tarif_types
                    .first
                    .tarifs
                    .create(prestation_type: organisation.prestation_types.first, 
                            prix: 1.00)

        # on ajoute l'utilisateur à l'organisation
        user.update(role: 'admin')
        organisation.users << user
    end

end
