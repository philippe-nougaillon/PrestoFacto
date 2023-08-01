class AddWorkflowStateOrganisationIdAndFactureSlugToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :organisation_id, :integer
    add_column :messages, :facture_slug, :string
    add_column :messages, :workflow_state, :string
    add_index :messages, :workflow_state
  end
end
