class FacturesToXls < ApplicationService
    require 'spreadsheet'    
    attr_reader :factures

    def initialize(factures)
        @factures = factures
    end

    def call
        headers = %w{ID Réf Date Compte Montant Mémo Etat Date_création Date_modification}
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Factures'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat headers
		sheet.row(0).default_format = bold
		
		index = 1
		@factures.each do |f|
			fields_to_export = [
                    f.id, 
                    f.réf,
                    f.date,
                    f.compte.nom,
                    f.montant,
                    f.mémo,
                    f.workflow_state.humanize,
                    f.created_at, 
                    f.updated_at
            ]
			sheet.row(index).replace fields_to_export
			index += 1
		end
	
		return book

    end
end