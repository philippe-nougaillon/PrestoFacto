class FacturePdf
    include Prawn::View
  
    # Taille et orientation du document par défaut
    def document
        @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    end

    def initialize
        @margin_down = 15
        @image_path =  "#{Rails.root}/app/assets/images/"
    end
  
    def export_facture(facture)
        compte = facture.compte
        organisation = compte.structure.organisation

        font 'Helvetica'
        font_size 11

        y_position = cursor
        bounding_box([0, y_position], :width => 300) do
            if organisation.logo.attached?
                logo = organisation.logo
                image StringIO.open(logo.download), width: 150
            end
        end
        bounding_box([300, y_position], :width => 300) do
            text "Facture n° #{ facture.réf }" 
            text "Statut : #{ facture.workflow_state.humanize }"
            text "Date : #{ I18n.l facture.date.to_date }"
        end
        move_down @margin_down 

        y_position = cursor
        bounding_box([0, y_position], :width => 300) do
            text "De :"
            text organisation.nom
            text compte.structure.nom
            text organisation.adresse
            text "#{ organisation.cp } #{ organisation.ville }"  
            text organisation.téléphone
            text organisation.email
        end
        bounding_box([300, y_position], :width => 300) do
            text "Pour :"
            text "#{ compte.civilité } #{ compte.nom }"
            text compte.adresse1
            text compte.adresse2
            text "#{ compte.cp } #{ compte.ville }"  
        end
        move_down @margin_down * 3

        data = [ ['Bénéficiaire', 'Prestation', 'Qté', 'Prix', 'Total'] ]
  
        facture.facture_lignes.each do | ligne |
            data += [ [
                    ligne.intitulé,
                    ligne.prestation_type.nom,
                    ligne.qté,
                    "%5.2f" % ligne.prix,
                    "%5.2f" % ligne.total
            ] ]
        end

        data += [ [ nil, nil, nil, nil, facture.montant ] ]

        table(data, 
            header: true, 
            column_widths: [200, 100, 50, 50, 50], 
            cell_style: { inline_format: true,  border_width: 0 }
        )

    end
end