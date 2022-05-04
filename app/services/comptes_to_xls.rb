class ComptesToXls < ApplicationService
    require 'spreadsheet'    
    attr_reader :comptes

    def initialize(comptes)
        @comptes = comptes
    end

    def call
        headers = %w{organisation nom_compte civilité adresse1 adresse2 cp ville num_allocataire mémo_compte
                    nom_enfant prénom classe référent date_naissance menu_sp menu_all tarif_type badge allergenes mémo_enfant
                    nom_contact1 fixe1 portable1 email1 prevenir1 mémo_contact1
                    nom_contact2 fixe2 portable2 email2 prevenir2 mémo_contact2
                    nom_contact3 fixe3 portable3 email3 prevenir3 mémo_contact3 }  
        Spreadsheet.client_encoding = 'UTF-8'

        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet name: 'Comptes'
        bold = Spreadsheet::Format.new :weight => :bold, :size => 10
    
        sheet.row(0).concat headers
        sheet.row(0).default_format = bold
        
        index = 1
        fields_to_export = []
            @comptes.each do |c|
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
end