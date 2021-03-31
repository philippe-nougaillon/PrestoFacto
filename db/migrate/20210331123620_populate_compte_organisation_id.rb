class PopulateCompteOrganisationId < ActiveRecord::Migration[6.1]
  def change
    Compte.all.each do | compte |
      organisation_id = compte.structure.organisation_id
      compte.update(organisation_id: organisation_id)
    end
  end
end
