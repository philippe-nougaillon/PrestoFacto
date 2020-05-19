class Classroom < ApplicationRecord
  audited
  
  belongs_to :structure, inverse_of: :classrooms

  has_many :enfants

  validates :structure_id, :nom, presence: true

end
