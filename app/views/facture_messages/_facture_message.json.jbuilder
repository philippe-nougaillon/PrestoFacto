json.extract! facture_message, :id, :contenu, :actif, :created_at, :updated_at
json.url facture_message_url(facture_message, format: :json)
