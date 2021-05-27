class Vacance < ApplicationRecord
    audited

    belongs_to :organisation, optional: true
  
    default_scope { order(Arel.sql('vacances.début')) }
end
