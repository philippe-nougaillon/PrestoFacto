class Paiement < ApplicationRecord
  belongs_to :compte

  has_one :organisation, through: :compte

  validates :date, presence: true

  validates :montant, numericality: { greater_than_or_equal_to: 0.01 }

  # self.per_page = 10

  def self.modes
     %w{Chèque Virement CB Espèces Autre}
  end

  def self.banques
    %w{AXA BNP\ Paribas Banque\ Populaire CIC Caisse\ d'épargne Crédit\ Agricole Crédit\ Mutuel La\ Banque\ POSTALE Société\ Générale Autre}
  end

  def self.xls_headers
    %w{ID Date Réf Compte Mode Banque Chèque_N° Montant Date_de_remise Mémo}
	end

  def self.to_xls(paiements)
    require 'spreadsheet'    
		
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Paiements'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat Paiement.xls_headers
		sheet.row(0).default_format = bold
		
		index = 1
		paiements.each do |p|
			fields_to_export = [
        p.id, 
        p.date,
        p.réf,
        p.compte.nom,
        p.mode,
        p.banque,
        p.chèque_num,
        p.montant,
        p.date_remise,
        p.mémo,
				p.created_at, 
				p.updated_at
			]
			sheet.row(index).replace fields_to_export
			index += 1
		end
	
		return book

  end

end
