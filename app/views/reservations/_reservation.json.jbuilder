json.extract! reservation, :id, :enfant_id, :prestation_type_id, :début, :fin, :lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche, :matin, :midi, :soir, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
