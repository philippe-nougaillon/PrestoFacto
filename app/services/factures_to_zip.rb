class FacturesToZip < ApplicationService
    require 'zip'
    attr_reader :factures

    def initialize(factures)
        @factures = factures
    end

    def call
        noms_utilisés = Hash.new(0)

        buffer = Zip::OutputStream.write_buffer do |zip|
            @factures.each do |facture|
                # Une instance par facture : FacturePdf mémoïse son document Prawn
                pdf = FacturePdf.new
                pdf.export_facture(facture)

                zip.put_next_entry(nom_fichier(facture, noms_utilisés))
                zip.write(pdf.render)
            end
        end

        buffer.string
    end

    private

        # "Facture_F2026-014.pdf", suffixé si 2 factures portent la même référence
        def nom_fichier(facture, noms_utilisés)
            base = "Facture_#{ facture.réf.to_s.gsub(/[^\w\-]+/, '_') }"
            noms_utilisés[base] += 1
            occurrence = noms_utilisés[base]

            occurrence > 1 ? "#{base}_#{occurrence}.pdf" : "#{base}.pdf"
        end
end
