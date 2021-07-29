class Reservation < ApplicationRecord
  include WorkflowActiverecord

  audited
  
  belongs_to :enfant
  belongs_to :prestation_type

  scope :actives, ->{ where(active: true) }

  # self.per_page = 10


  AJOUTEE   = 'ajoutée'
  VALIDEE   = 'validée'
  REJETEE   = 'rejetée'

  workflow do
    state AJOUTEE, meta: { style: 'bg-info' } do
      event :valider, transitions_to: VALIDEE
      event :rejeter, transitions_to: REJETEE
    end

    state VALIDEE, meta: { style: 'bg-success' } 

    state REJETEE, meta: { style: 'bg-danger' }

    after_transition do |from, to, triggering_event, *event_args|
      logger.debug "[WORKFLOW RESERVATION] #{from} -> #{to} #{triggering_event}"
    end
  end

  # pour que le changement se voit dans l'audit trail
  def persist_workflow_state(new_value)
    self[:workflow_state] = new_value
    save!
  end

  def style
    self.current_state.meta[:style]
  end


end
