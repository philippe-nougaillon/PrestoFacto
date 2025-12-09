namespace :prestations do

  desc "Comptabiliser les prestations consommées sur la base des reservations"
  task :ajouter, [:current_user_id, :enregistrer, :date] => :environment do |task, args|

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

    unless args.date    
      # Comme le traitement a lieu toutes les 24 heures, mais que l'on ne sait pas quand (anacron)
      # on doit comptabiliser le jour précédent (par sécurité)
      date = Date.today - 1.day
    else
      # sinon, on vient de l'admin
      date = Date.parse(args.date)
    end

    organisations.each do |organisation|

      puts "- " * 50
      puts "Organisation: #{ organisation.nom }"

      vacances = Vacance.where(zone: organisation.zone)
                        .or(Vacance.where(organisation_id: organisation.id))
                        .where("DATE(?) BETWEEN début AND fin", date)

      hors_période_scolaire = vacances.any?
      puts "Jour à comptabiliser: #{I18n.l date}." \
           " Ce jour est #{hors_période_scolaire ? "hors période scolaire => #{vacances.first.nom}}" : "en période_scolaire" }" 

      reservations = organisation.reservations
                                  .actives
                                  .where(workflow_state: 'validée')
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
              puts "Le jour de la semaine correspond à la réservation. Quantité réservée = #{qté_reservée}" 
              if reservation.prestation_type.forfaitaire?
                presta = enfant.prestations.new(prestation_type: reservation.prestation_type, date: date, qté: qté_reservée) 
                if presta.valid?
                  presta.save if enregistrer
                  puts "OK Prestation créée "   
                  prestations_ajoutées += 1   
                else
                  puts "KO Création de prestation forfaitaire a échoué => #{presta.errors.messages}"  
                end
              else
                if tranches_consommées = enfant.pointages.find_by(prestation_type: reservation.prestation_type, date_pointage: date).try(:tranches_consommées)
                  puts "Tranches consommées : #{tranches_consommées}"
                  presta = enfant.prestations.new(prestation_type: reservation.prestation_type, date: date, qté: tranches_consommées) 
                  if presta.valid?
                    presta.save if enregistrer
                    puts "OK Prestation créée "   
                    prestations_ajoutées += 1   
                  else
                    puts "KO ! Création de prestation par tranche a échoué => #{presta.errors.messages}"  
                  end
                end
                # Créer la feuille de pointage du jour suivant
                Pointage.find_or_create_by(date_pointage: date.tomorrow, enfant_id: enfant.id, prestation_type_id: reservation.prestation_type.id)
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
    when 1
      reservation.lundi
    when 2 
      reservation.mardi
    when 3
      reservation.mercredi
    when 4
      reservation.jeudi
    when 5
      reservation.vendredi
    when 6
      reservation.samedi
    when 7
      reservation.dimanche
    else
      0
    end

  end

end
