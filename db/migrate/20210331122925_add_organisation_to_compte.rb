class AddOrganisationToCompte < ActiveRecord::Migration[6.1]
  def change
    add_reference :comptes, :organisation, foreign_key: true
  end
end
