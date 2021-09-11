class Absence < ApplicationRecord
  audited
  
  belongs_to :enfant

  validates :début, :fin, presence: true

  has_one :organisation, through: :enfant

  default_scope { where(archive: false) }

end
