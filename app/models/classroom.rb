class Classroom < ApplicationRecord
  audited
  
  belongs_to :structure, inverse_of: :classrooms

  has_many :enfants

  validates :structure_id, :nom, presence: true

  def nom_et_structure
    self.nom + ' (' + self.structure.nom + ')'
  end

end
