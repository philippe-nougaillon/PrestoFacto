class FacturePdf
    include Prawn::View
  
    # Taille et orientation du document par défaut
    def document
        @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    end

    def initialize
        @margin_down = 11
        @image_path =  "#{Rails.root}/app/assets/images/"
    end
  
    def export_facture(facture)
        compte = facture.compte
        organisation = compte.structure.organisation

        font 'Helvetica'
        font_size 12

        y_position = cursor
        bounding_box([0, y_position], :width => 300) do
            if organisation.logo.attached?
                logo = organisation.logo
                image StringIO.open(logo.download), width: 70
            end
            move_down @margin_down 

            formatted_text [{ text: organisation.nom, styles: [:bold] }] 
            text compte.structure.nom
            text organisation.adresse
            text "#{ organisation.cp } #{ organisation.ville }"  
            move_down @margin_down 
            text organisation.téléphone
            text organisation.email
            move_down @margin_down 
        end

        bounding_box([300, y_position], :width => 300) do
            formatted_text [
                { text: 'Date : ', color: 'C0C0C0' },
                { text: I18n.l(facture.date.to_date) }
            ]

            formatted_text [
                { text: 'Statut : ', color: 'C0C0C0' },
                { text: facture.workflow_state }
            ]
            move_down @margin_down  * 8

            formatted_text [{ text: "#{ compte.civilité } #{ compte.nom }", styles: [:bold] }] 
            text compte.adresse1
            text compte.adresse2
            text "#{ compte.cp } #{ compte.ville }"  

        end
        move_down @margin_down * 5

        formatted_text([
            { text: 'Facture n° ', color: 'C0C0C0' },
            { text: facture.réf  , styles: [:bold] }
        ])
        move_down @margin_down 

        # 
        # Tableau de lignes de facture
        #
        
        col_widths = [260, 100, 50, 50, 60]
        cell_style = { 
            inline_format: true,
            border_width: 1,
            borders: [:bottom],
            border_color: 'DEDEDE'
        }

        # Générer les entêtes du tableau
        table(
            [ ['Bénéficiaire', 'Prestation', 'Qté', 'Prix.U', 'Total'] ], 
            column_widths: col_widths, 
            cell_style: cell_style.merge(text_color: 'C0C0C0')
        )

        # Lignes
        data = []
        facture.facture_lignes.each do | ligne |
            data += [ [
                        "<b>#{ligne.intitulé}</b>",
                        ligne.prestation_type.nom,
                        "%5.2f" % ligne.qté,
                        "%5.2f €" % ligne.prix,
                        "<b>#{ "%5.2f €" % ligne.total }</b>"
                    ] ]
        end

        # Total
        data += [ [ nil, nil, nil, "Total : ", "<b> %5.2f € </b>" % facture.montant ] ]

        # Générer le tableau
        table(
            data, 
            column_widths: col_widths, 
            cell_style: cell_style
        )

    end
end