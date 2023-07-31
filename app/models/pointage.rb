class Pointage < ApplicationRecord
  audited

  belongs_to :enfant
  belongs_to :prestation_type

  def minutes_consommées
    if self.heure_pointage
      if self.prestation_type.pointage_arrivee
        fin = DateTime.parse("#{self.date_pointage}T#{self.prestation_type.fin}")
        return (fin.to_i - self.heure_pointage.to_i) / 60
      else
        debut = DateTime.parse("#{self.date_pointage}T#{self.prestation_type.debut}")
        return (self.heure_pointage.to_i - debut.to_i) / 60
      end
    end
  end

  def tranches_consommées
    (self.minutes_consommées.to_f / self.prestation_type.duree_tranche).ceil
  end
end
