json.extract! message, :id, :email, :objet, :contenu, :created_at, :updated_at
json.url message_url(message, format: :json)
