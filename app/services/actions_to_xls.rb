class ActionsToXls < ApplicationService
    require 'spreadsheet'    
    attr_reader :actions

    def initialize(actions)
        @actions = actions
    end

    def call
        headers = %w{ Id Date_création Maison Organisation Nom_Contact Prénom_Contact Fonction_contact Téléphone_Contact Email_Contact Qui Intitulé_Action Fait? Date_rappel Mémo_Action Date_MAJ }
    
        Spreadsheet.client_encoding = 'UTF-8'
    
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet name: 'Actions'
        bold = Spreadsheet::Format.new :weight => :bold, :size => 11
    
        sheet.row(0).concat headers
        sheet.row(0).default_format = bold
    
        index = 1
        @actions.each do | action |
          fields_to_export = [
            action.id, 
            action.created_at, 
            action.contact.try(:maison).try(:nom),
            action.contact.organisation,
            action.contact.nom,
            action.contact.prénom,
            action.contact.fonction,
            action.contact.téléphone,
            action.contact.email,
            action.user.email,
            action.intitulé,
            (action.fait ? 'Oui' : nil),
            action.date_rappel, 
            action.mémo,
            action.updated_at
          ]
          sheet.row(index).replace fields_to_export
          index += 1
        end
        return book
    end
    
end