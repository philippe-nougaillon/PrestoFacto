class Compte < ApplicationRecord
  extend FriendlyId
  friendly_id :nom, use: :slugged

  audited

  belongs_to :organisation 

  validates :nom, presence: true

  has_many :contacts, inverse_of: :compte, dependent: :delete_all
  has_many :enfants, dependent: :delete_all
  has_many :factures
  has_many :paiements

  has_many :prestations, through: :enfants
  has_many :reservations, through: :enfants

  accepts_nested_attributes_for :contacts, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

  default_scope { order(Arel.sql('comptes.nom')) }

  # self.per_page = 10

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
