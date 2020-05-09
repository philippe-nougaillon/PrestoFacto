json.extract! paiement, :id, :compte_id, :réf, :mode, :banque, :chèque_num, :montant, :date_remise, :mémo, :created_at, :updated_at
json.url paiement_url(paiement, format: :json)
