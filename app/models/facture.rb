class Facture < ApplicationRecord
  include WorkflowActiverecord
  
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited
  
  belongs_to :compte
  has_many :facture_lignes, dependent: :destroy
  has_many :prestations

  validates :réf, presence: true
  validates_uniqueness_of :réf, scope: [:compte_id]

  accepts_nested_attributes_for :facture_lignes, reject_if: proc { |attributes| attributes[:intitulé].blank? }, allow_destroy: true

  default_scope { order(Arel.sql("factures.réf DESC")) }
  scope :non_envoyées, -> { where(Arel.sql("factures.envoyée_le IS NULL")) }

  before_destroy :maj_prestations

  self.per_page = 10


  AJOUTEE   = 'ajoutée'
  VERIFIEE  = 'vérifiée'
  ENVOYEE   = 'envoyée'
  RELANCE1  = 'relance1'
  RELANCE2  = 'relance2'
  RELANCE3  = 'relance3'
  PAYEE     = 'payée'
  REJETEE   = 'rejetée'
  IMPUTEE   = 'imputée'

  workflow do
    state AJOUTEE, meta: {style: 'badge-info'} do
      event :verifier, transitions_to: VERIFIEE
    end

    state VERIFIEE, meta: {style: 'badge-primary'} do
      event :envoyer, transitions_to: ENVOYEE
    end

    state ENVOYEE, meta: {style: 'badge-warning'} do
      event :payer, transitions_to: PAYEE
      event :rejeter, transitions_to: REJETEE
      event :relancer, transitions_to: RELANCE1
    end

    state RELANCE1, meta: {style: 'badge-secondary'} do
      event :payer, transitions_to: PAYEE
      event :rejeter, transitions_to: REJETEE
      event :relancer, transitions_to:  RELANCE2
    end

    state RELANCE2, meta: {style: 'badge-secondary'} do
      event :payer, transitions_to: PAYEE
      event :rejeter, transitions_to: REJETEE
      event :relancer, transitions_to: RELANCE3
    end

    state RELANCE3, meta: {style: 'badge-secondary'} do
      event :payer, transitions_to: PAYEE
      event :rejeter, transitions_to: REJETEE
      event :relancer, transitions_to: RELANCE1
    end

    state PAYEE, meta: {style: 'badge-success'} do
      event :imputer, transitions_to: IMPUTEE
    end

    state REJETEE, meta: {style: 'badge-danger'}

    state IMPUTEE, meta: {style: 'badge-dark'}

    after_transition do |from, to, triggering_event, *event_args|
      logger.debug "[WORKFLOW] #{from} -> #{to} #{triggering_event}"
    end
  end

  # pour que le changement se voit dans l'audit trail
  def persist_workflow_state(new_value)
    self[:workflow_state] = new_value
    save!
  end

  def style
    self.current_state.meta[:style]
  end

  def self.fabrique_une_référence_facture(index)
    "#{Date.today.month}-#{Date.today.year}/#{index}"
  end

  def self.xls_headers
		%w{ID Réf Date Compte Montant Mémo}
	end

  def self.to_xls(factures)
    require 'spreadsheet'    
		
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Factures'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat Facture.xls_headers
		sheet.row(0).default_format = bold
		
		index = 1
		factures.each do |f|
			fields_to_export = [
        f.id, 
        f.réf,
        f.date,
        f.compte.nom,
        f.montant,
        f.mémo,
				f.created_at, 
				f.updated_at
			]
			sheet.row(index).replace fields_to_export
			index += 1
		end
	
		return book

  end

private
  
  # only one candidate for an nice id; one random UDID
  def slug_candidates
    [SecureRandom.uuid]
  end


  def maj_prestations
    # libérer les prestations liées à la facture qui va être détruite (= prestations non facturées)
    self.prestations.update(facture_id: nil)
  end

end
