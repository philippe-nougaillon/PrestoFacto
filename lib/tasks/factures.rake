namespace :factures do
    
    desc "Facturation"
    task :facturer, [:current_user_id, :enregistrer, :date, :compte] => :environment do |task, args|

        enregistrer = (args[:enregistrer] == '1')    
        puts "Enregistrer les modifications !" if enregistrer
        
        user = User.find(args.current_user_id)
        puts "current_user id = #{user.id}"

        date_début = args.date
        date_fin = date_début.end_of_month
        puts "Facturation des prestations du #{I18n.l date_début} au #{I18n.l date_fin}"

        # quels sont les comptes ayants des prestations consommées durant la période ?
        if args[:compte] == nil
            puts "Facturer tous les comptes"
            comptes = Prestation
                        .à_facturer
                        .where("date BETWEEN DATE(?) AND (?)", date_début, date_fin)
                        .joins(:enfant)
                        .group("enfants.compte_id")
                        .select(:id)
                        .count(:id)
        else
            puts "Facturer que le compte: #{ args[:compte] }"
            comptes = Compte
                        .where(id: args[:compte])
                        .group(:id)
                        .select(:id)
                        .count(:id)
        end 

        # pour chaque compte, faire le chiffrage des prestations consommées
        comptes.each do |id, count|

            # Test si ce compte appartient à l'utilisateur connecté
            # TODO: inclure ce test dans la requête précédente 
            # TODO: prestations = user.organisation.prestations
            # TODO: déjà essayé mais en vain. alors faute de mieux, on garde ça 
            next unless user.organisation.comptes.pluck(:id).include?(id)    

            compte = Compte.find(id)
            puts "Compte: #{compte.nom} (#{compte.id}) = #{count} prestations consommées"

            # incrémenter le numéro de chrono de facture
            chrono = compte.organisation.facture_chronos.last
            index = chrono.index + 1
            montant_total = 0.0

            # créer l'entête de facture
            facture = compte.factures.new(
                réf: Facture.fabrique_une_référence_facture(index), 
                date: DateTime.now, 
                échéance: Date.today + 1.month, 
                mémo: "Période du #{I18n.l date_début} au #{I18n.l date_fin}"
            )
            
            facture.save if enregistrer
            
            # totaliser les prestations consommées par ce compte durant la période
            prestations = compte.prestations.à_facturer.where("date BETWEEN DATE(?) AND (?)", date_début, date_fin)

            # Exclure les prestations ayant eu lieu un jour d'absence
            prestations_absences = []
            prestations.each do | prestation |
                if Absence.where(enfant_id: prestation.enfant_id)
                            .where("? BETWEEN début and fin", prestation.date).any?
                    puts "Détection d'une prestation un jour d'absence le #{I18n.l prestation.date}. La prestation sera ignorée."
                    prestations_absences << prestation.id
                end
            end

            prestations = prestations.where.not(id: prestations_absences)

            # regrouper par enfant, par type de prestations et en faire le cumul des quantités
            prestations.select("enfant_id, prestation_type_id, sum(qté) as quantité")
                        .group("enfant_id, prestation_type_id")
                        .reorder(:enfant_id, :prestation_type_id)
                        .each do |presta|

                        # Trouver le prix pour ce type de prestation selon le barème de l'enfant    
                        prix = PrestationType.find(presta.prestation_type_id).tarifs.find_by(tarif_type_id: presta.enfant.tarif_type_id).prix

                        # Calculer le total de la ligne et le total de la facure
                        total = prix * presta.quantité    
                        montant_total += total

                        puts "[Prestations] enfant: #{ presta.enfant.prénom }(##{ presta.enfant_id }) type: #{ presta.prestation_type_id } qté: #{ presta.quantité.to_f }, total: #{total} €"

                        # créer la ligne de facture
                        ligne = facture.facture_lignes.new(intitulé: Enfant.find(presta.enfant_id).nom_et_prénom, prestation_type: presta.prestation_type, qté: presta.quantité.to_f, prix: prix, total: total)    
                        if ligne.valid?
                            ligne.save if enregistrer
                            puts "Ligne: #{ligne.valid?}" 
                        end  
            end

            # MAJ du prestation.facture_id pour indiquer que cette prestation a été facturée
            prestations.update_all(facture_id: facture.id) if enregistrer

            puts "Montant total: #{montant_total} €"
            facture.montant = montant_total

            # Calculer le solde du compte avant et après cette facture
            facture.solde_avant = compte.solde_avant_cette_facture(facture)
            facture.solde_après = compte.solde

            # Finalisation facture et enregistrement du chrono facture si la facture est enregistrée    
            if facture.valid?
                facture.save if enregistrer

                # MAJ du Chrono N° de facture
                chrono.index = index
                chrono.save if enregistrer

                puts "OK => FACTURE #{facture.réf} créée"
                puts "OK => #{facture.facture_lignes.size} lignes de détail facture créées"
                puts "- " * 60
            else
                puts "KO !!"
            end
        end
        puts "FIN"
    end
end  