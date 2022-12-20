class MailLog < ApplicationRecord
  include Sortable::Model

  belongs_to :organisation
end
