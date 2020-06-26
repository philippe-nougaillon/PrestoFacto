class AddWorkflowStateToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :workflow_state, :string
  end
end
