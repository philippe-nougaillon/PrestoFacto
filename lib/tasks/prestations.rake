namespace :prestations do

  desc "Comptabiliser les prestations consommées sur la base des reservations"
  task :ajouter, [:current_user_id, :enregistrer] => :environment do |task, args|

    # Tester si la routine est lancée par le système (par d'args) ou par un utilisateur
    enregistrer = if args.enregistrer
      (args.enregistrer == "1")
    else
      true
    end
    puts "Enregistrer les changements !" if enregistrer

    current_user_id = args.current_user_id
    # puts "current_user_id: #{current_user_id}"

    if args.current_user_id
      # Obtenir une ActiveRecord::Relation pour une seule organisation
      organisations = Organisation.where(id: User.find(current_user_id).organisation.id)
    else
      # Tâche lancée par le système => on comptabilise pour toutes les organisations
      organisations = Organisation.all
    end

    # puts "Nombres d'Organisations à traiter : #{organisations.size}"

    # Comme le traitement a lieu toutes les 24 heures, mais que l'on ne sait pas quand (anacron)
    # on doit comptabiliser le jour précédent (par sécurité)

    date = Date.today - 1.day
    vacances = Vacance.where("DATE(?) BETWEEN début AND fin", date)
    hors_période_scolaire = vacances.any?
    puts "Jour à comptabiliser: #{I18n.l date}." \
         " Ce jour est #{hors_période_scolaire ? "hors période scolaire" : "en période_scolaire" }" \
         " => #{ hors_période_scolaire ? vacances.first.nom : '' }"

    organisations.each do |organisation|
      puts "- " * 50
      puts "Organisation: #{ organisation.nom }"

      reservations = organisation.reservations
                                  .actives
                                  .where(hors_période_scolaire: hors_période_scolaire)
                                  .where("DATE(?) BETWEEN début AND fin", date)

      puts "#{ reservations.size } réservation(s) active(s) pour cette organisation"

      prestations_ajoutées = 0
      puts "+ " * 50  

      reservations.each do | reservation |
        enfant = reservation.enfant 
        puts "=> #{ enfant.nom_et_prénom }"

        enfant_reservations = reservations.where(enfant_id: enfant.id)
        puts "#{ reservations.size } réservations"

        absences = enfant.absences.where("DATE(?) BETWEEN début AND fin", date).any?
        puts "Des absences ? = #{ I18n.t absences }"
        
        if enfant_reservations.any? and !(absences)
          puts "PRESTATIONS CONSOMMÉES :"
          enfant_reservations.each do |reservation|
            puts reservation.prestation_type.nom
            qté_reservée = jour_semaine_match?(date, reservation)
            
            if qté_reservée > 0
              puts "Le jour de la semaine correspond à la réservation. Quantité = #{qté_reservée}" 
              presta = enfant.prestations.new(prestation_type: reservation.prestation_type, date: date, qté: qté_reservée) 
              if presta.valid?
                presta.save if enregistrer
                puts "OK Prestation créée "   
                prestations_ajoutées += 1   
              else
                puts "KO Création de prestation a échoué => #{presta.errors.messages}"  
              end  
            else
              puts "pas de quantité consommée (jour ne match pas ?)"
            end
          end
        end
        puts "+ " * 50  
      end
      puts "Total prestations consommées : #{prestations_ajoutées}"
      puts "Les changements ont été enregistrés" if enregistrer
    end
      
  end

  def jour_semaine_match?(date, reservation)

    # il y a t il dans la réservation le jour de la semaine passé en param (date) ?
    # si oui, on renvoit la quantité indiquée dans la réservation

    case date.wday
    when 0 
      reservation.lundi
    when 1 
      reservation.mardi
    when 2
      reservation.mercredi
    when 3
      reservation.jeudi
    when 4
      reservation.vendredi
    else
      0
    end

  end

end
