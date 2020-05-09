json.extract! facture, :id, :compte_id, :réf, :date, :échéance, :envoyée_le, :montant, :vérifiée, :mémo, :created_at, :updated_at
json.url facture_url(facture, format: :json)
