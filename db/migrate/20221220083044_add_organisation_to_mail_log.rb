class AddOrganisationToMailLog < ActiveRecord::Migration[6.1]
  def change
    add_reference :mail_logs, :organisation, null: false, foreign_key: true
  end
end
