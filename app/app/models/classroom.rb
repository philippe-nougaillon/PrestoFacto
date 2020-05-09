class Classroom < ApplicationRecord
  audited
  
  belongs_to :structure, inverse_of: :classrooms

  has_many :enfants

end
