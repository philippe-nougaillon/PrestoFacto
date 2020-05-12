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
    puts "current_user_id: #{current_user_id}"

    if args.current_user_id
      # Obtenir une ActiveRecord::Relation pour une seule organisation
      organisations = Organisation.where(id: User.find(current_user_id).organisation.id)
    else
      # Tâche lancée par le système => on comptabilise pour toutes les organisations
      organisations = Organisation.all
    end

    puts "Nombres d'Organisation à traiter : #{organisations.size}"

    # Comme le traitement a lieu toutes les 24 heures, mais que l'on ne sait pas quand (anacron)
    # on doit comptabiliser le jour précédent (par sécurité)

    date = Date.today - 1.day
    puts "Jour à comptabiliser: #{date}"

    hors_période_scolaire = Vacance.where("DATE(?) BETWEEN début AND fin", date).any?
    puts "Jour hors_période_scolaire ? = #{I18n.t hors_période_scolaire}"

    organisations.each do |organisation|
      puts "@-@ " * 20
      puts organisation.nom
      puts "#{organisation.reservations.actives.size} réservation.s active.s au total pour cette organisation"

      prestations_ajoutées = 0

      organisation.enfants.each do |enfant|
        puts "=> #{enfant.nom_et_prénom}"

        reservations = enfant.reservations
                              .actives
                              .where(hors_période_scolaire: hors_période_scolaire)
                              .where("DATE(?) BETWEEN début AND fin", date)
        
        puts "#{reservations.size} réservations"

        absences = enfant.absences.where("DATE(?) BETWEEN début AND fin", date).any?
        puts "Des absences ? = #{I18n.t absences}"

        if reservations.any? and !(absences)
          puts "PRESTATIONS CONSOMMÉES :"
          reservations.each do |reservation|
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
        puts "+ " * 40  
      end
      puts "Total prestations consommées : #{prestations_ajoutées}"
      puts "Les changements ont été enregistrés" if enregistrer
    end
      
  end

  def jour_semaine_match?(date, reservation)

    # il y a t il dans la réservation le jour de la semaine passé en param (date) ?
    # si oui, on renvoit la quantité indiquée dans la réservation

    case date.wday
    when 1 # lundi
      reservation.lundi
    when 2 # mardi
      reservation.mardi
    when 3
      reservation.mercredi
    when 4
      reservation.jeudi
    when 5
      reservation.vendredi
    else
      0
    end

  end

end
