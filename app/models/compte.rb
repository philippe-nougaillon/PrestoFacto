class Compte < ApplicationRecord
  extend FriendlyId
  friendly_id :nom, use: :slugged

  audited

  belongs_to :organisation 

  has_many :contacts, inverse_of: :compte, dependent: :delete_all
  has_many :enfants, dependent: :delete_all
  has_many :factures
  has_many :paiements

  has_many :prestations, through: :enfants
  has_many :reservations, through: :enfants

  accepts_nested_attributes_for :contacts, reject_if: proc { |attributes| attributes[:nom].blank? }, allow_destroy: true

  
  # self.per_page = 10

  default_scope { order(Arel.sql('comptes.nom')) }

  def self.xls_headers
    %w{organisation nom_compte civilité adresse1 adresse2 cp ville num_allocataire mémo_compte
        nom_enfant prénom classe référent date_naissance menu_sp menu_all tarif_type badge allergenes mémo_enfant
        nom_contact1 fixe1 portable1 email1 prevenir1 mémo_contact1
        nom_contact2 fixe2 portable2 email2 prevenir2 mémo_contact2
        nom_contact3 fixe3 portable3 email3 prevenir3 mémo_contact3 }  
  end

  def self.to_xls(comptes)
    require 'spreadsheet'    
		
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Comptes'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat Compte.xls_headers
		sheet.row(0).default_format = bold
		
		index = 1
    fields_to_export = []
		comptes.each do |c|
      c.enfants.each do |e|
        fields_to_export = [
          c.organisation.nom,
          c.nom,
          c.civilité,
          c.adresse1,
          c.adresse2,
          c.cp,
          c.ville,
          c.num_allocataire,
          c.mémo,
          e.nom,
          e.prénom,
          e.classroom.nom,
          e.classroom.référent,
          e.date_naissance,
          e.menu_sp,
          e.menu_all,
          e.tarif_type,
          e.badge,
          e.allergenes,
          e.mémo
        ]
        c.contacts.each do |contact|
          fields_to_export << [
            contact.nom,
            contact.fixe,
            contact.portable,
            contact.email,
            contact.prevenir,
            contact.mémo
          ] 
        end
        sheet.row(index).replace fields_to_export.flatten
        index += 1
      end
		end
	
		return book

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
