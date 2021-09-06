class Vacance < ApplicationRecord
    audited

    belongs_to :organisation, optional: true

    validates :nom, :début, :fin, presence: true
  
    default_scope { order(Arel.sql('vacances.début')) }
end
