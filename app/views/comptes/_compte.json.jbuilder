json.extract! compte, :id, :structure_id, :nom, :civilité, :adresse1, :adresse2, :cp, :ville, :num_allocataire, :mémo, :created_at, :updated_at
json.url compte_url(compte, format: :json)
