class AddOrganisationReferenceToVacances < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacances, :organisation, foreign_key: true
  end
end
