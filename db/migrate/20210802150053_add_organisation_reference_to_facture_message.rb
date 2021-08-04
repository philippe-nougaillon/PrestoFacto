class AddOrganisationReferenceToFactureMessage < ActiveRecord::Migration[6.1]
  def change
    add_reference :facture_messages, :organisation, null: false, foreign_key: true
  end
end
