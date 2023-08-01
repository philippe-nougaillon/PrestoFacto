class Message < ApplicationRecord
  audited

  include Workflow
  include WorkflowActiverecord

  belongs_to :organisation, optional: true

  validates :email, :objet, :contenu, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  scope :ordered, -> { order(updated_at: :desc)}

  # paginates_per 2


  # WORKFLOW
  NOUVEAU   = 'nouveau'
  TRAITE    = 'traité'
  ARCHIVE   = 'archivé'

  workflow do
    state NOUVEAU, meta: { style: 'warning' } do
      event :traiter, transitions_to: TRAITE
    end

    state TRAITE, meta: { style: 'success' } do
      event :archiver, transitions_to: ARCHIVE
    end

    state ARCHIVE, meta: { style: 'secondary' }

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
