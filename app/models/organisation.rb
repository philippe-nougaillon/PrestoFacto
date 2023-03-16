class Organisation < ApplicationRecord
    extend FriendlyId
    friendly_id :nom, use: :slugged

    audited
    
    has_one_attached :logo

    has_many :structures, inverse_of: :organisation
    accepts_nested_attributes_for :structures, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

    has_many :vacances
    accepts_nested_attributes_for :vacances, reject_if: proc { |attrs| attrs[:nom].blank? && attrs[:début].blank? && attrs[:fin].blank? }, allow_destroy: true

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
    has_many :facture_messages
    has_many :mail_logs

    validates :nom, :email, presence: true

    def self.create_from_signup(user, organisation, structure, zone)
        # On crée l'organisation 
        organisation = Organisation.create( nom: organisation, 
                                            email: user.email, 
                                            zone: zone)

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

        enfant = organisation.comptes.first
                             .enfants.create(classroom: organisation.classrooms.first, 
                                    nom: 'TEST', 
                                    prénom: 'Martin', 
                                    date_naissance: Date.today,
                                    tarif_type: organisation.tarif_types.first)

        enfant.reservations.create(prestation_type: organisation.prestation_types.first,
                                    début: Date.today,
                                    fin: Date.today.end_of_year,
                                    lundi: 1,
                                    mardi: 1,
                                    mercredi: 1,
                                    jeudi: 1,
                                    vendredi: 1,
                                    midi: true,
                                    workflow_state: 'validée')

        # on surclasse l'utilisateur et on l'ajoute à l'organisation
        user.update(role: 'admin')
        organisation.users << user
    end

    def vacances_été 
        été = Vacance
                .where(zone: self.zone)
                .where(nom: "Vacance d'été")
                .where("EXTRACT(YEAR FROM vacances.début) = ?", Date.today.year)

        if été.any?
            été.first
        else
            Vacance.new(début: Date.today.end_of_year - 1.year, fin: Date.today)
        end    
    end

    def en_dépassement_plan_gratuit?
        self.factures.count >= 1000
    end

end
