class FixNullIssueToPrestationArchive < ActiveRecord::Migration[6.1]  
  def change
    say "Remise à false des Prestations & Absences"
    Absence.unscoped.update_all(archive: false)
    Prestation.unscoped.update_all(archive: false)
 
    say "Migration"
    change_column :prestations, :archive, :boolean, null: false, default: false
    change_column :absences, :archive, :boolean, null: false, default: false

    say "Mise en archive"
    Absence.where("DATE(début) <= '2021-09-01'").update(archive: true)
    Prestation.where("DATE(date) <= '2021-09-01'").update(archive: true)
  end
end
