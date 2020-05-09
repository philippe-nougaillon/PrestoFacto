class FactureLigne < ApplicationRecord
  audited
  
  belongs_to :facture
  belongs_to :prestation_type
end
