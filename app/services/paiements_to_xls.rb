class PaiementsToXls < ApplicationService
    require 'spreadsheet'    
    attr_reader :paiements

    def initialize(paiements)
        @paiements = paiements
    end

    def call
        headers = %w{ID Date Réf Compte Mode Banque Chèque_N° Montant Date_de_remise Mémo}
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Paiements'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat headers
		sheet.row(0).default_format = bold
		
		index = 1
		@paiements.each do |p|
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