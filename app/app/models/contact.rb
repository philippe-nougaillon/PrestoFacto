class Contact < ApplicationRecord
  audited
  
  belongs_to :compte, inverse_of: :contacts

end
