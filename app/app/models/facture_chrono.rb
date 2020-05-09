class FactureChrono < ApplicationRecord
  audited
  
  belongs_to :organisation
end
