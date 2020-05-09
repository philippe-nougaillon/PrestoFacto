class Vacance < ApplicationRecord
    audited
  
    default_scope { order(Arel.sql('vacances.début')) }
end
