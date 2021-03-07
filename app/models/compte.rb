class Compte < ApplicationRecord
  extend FriendlyId
  friendly_id :nom, use: :slugged

  audited

  belongs_to :structure

  has_one :organisation, through: :structure

  has_many :contacts, inverse_of: :compte, dependent: :delete_all
  has_many :enfants, dependent: :delete_all
  has_many :classrooms
  has_many :factures
  has_many :paiements

  has_many :prestations, through: :enfants
  has_many :reservations, through: :enfants

  accepts_nested_attributes_for :contacts, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

  validates :structure_id, :nom, presence: true

  self.per_page = 10

  default_scope { order(Arel.sql('comptes.nom')) }

  def self.xls_headers
    %w{structure nom_compte civilité adresse1 adresse2 cp ville num_allocataire mémo_compte
        nom_contact fixe portable email mémo_contact 
        nom_enfant prénom classe date_naissance menu_sp menu_all tarif_type badge
        prestation_type début fin lundi mardi mercredi jeudi vendredi matin midi soir active hors_période_scolaire}  
  end

  def balance
    solde = 0.00 
    debit = 0.00 
    credit = 0.00
    releve = []

    self.factures.each do |f|
      releve << { id: f.id, date: f.date.to_date, type: "Facture", ref: f.réf, mnt: f.montant, solde: 0 }
    end

    self.paiements.each do |p|
      releve << { id: p.id, date: p.date.to_date, type: "Paiement", ref: "#{p.mode} #{p.banque} #{p.chèque_num}", mnt: p.montant, solde: 0 }
    end

    releve = releve.sort_by { |r| r[:date] }

    releve.each do |r|
      mnt = r[:mnt]
      if r[:type] == "Facture"
        debit += mnt
        solde -= mnt
      else
        credit += mnt
        solde += mnt
      end
      r[:solde] = solde
    end 
  end

  def solde_avant_cette_facture(facture)
    self.paiements.sum(:montant) - (self.factures.sum(:montant) - facture.montant)
  end

  def solde
    self.paiements.sum(:montant) - self.factures.sum(:montant)
  end


end
