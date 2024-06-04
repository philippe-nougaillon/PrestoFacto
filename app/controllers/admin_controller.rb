class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: [:mode_demonstration]
  before_action :user_authorized?, except: %i[mode_demonstration]

  skip_before_action :verify_authenticity_token
  # production => config.force_ssl = true

  def index
    @unread_messages = current_user.organisation.messages.where(workflow_state: "nouveau").count
  end

  def ajout_prestations
  end

  def ajout_prestations_do
    require 'rake'

    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Rails.application.load_tasks # providing your application name is 'sample'
      
    # capture output
    @stdout_stream = capture_stdout do
      Rake::Task['prestations:ajouter'].reenable # in case you're going to invoke the same task second time.
      Rake::Task['prestations:ajouter'].invoke(current_user.id, params[:enregistrer], params[:date])
    end

    # Garder une trace dans un fichier de log
    if params[:enregistrer] == '1'
      f = File.new("log/prestations_#{DateTime.now}.log", 'w')
      f << @stdout_stream
      f.close
    end
  end

  def ajout_factures

  end

  def ajout_factures_do
    date = Date.new(params["[date(1i)]"].to_i,
                    params["[date(2i)]"].to_i,
                    params["[date(3i)]"].to_i)
        
    require 'rake'

    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Rails.application.load_tasks # providing your application name is 'sample'
      
    # capture output
    @stdout_stream = capture_stdout do
      Rake::Task['factures:facturer'].reenable # in case you're going to invoke the same task second time.
      Rake::Task['factures:facturer'].invoke(current_user.id, params[:enregistrer], date, params[:compte_id])
    end

    # Garder une trace dans un fichier de log
    if params[:enregistrer] == '1'
      f = File.new("log/factures_#{DateTime.now}.log", 'w')
      f << @stdout_stream
      f.close
    end
    
  end

  def tarifs
    @organisation = current_user.organisation
  end

  def audit
    @audits = Audited::Audit
                  .where(user_id: current_user.organisation.users)
                  .order("id DESC")
                  
    @types  = @audits.pluck(:auditable_type).uniq.sort
    @users  = current_user.organisation.users
    
    unless params[:date].blank?  
      @audits = @audits.where("DATE(created_at) = ?", params[:date])
    end

    unless params[:type].blank?
      @audits = @audits.where(auditable_type: params[:type])
    end

    unless params[:user_id].blank?
      @audits = @audits.where(user_id: params[:user_id])
    end
              
    @audits = @audits.page(params[:page])

  end

  def import
    
  end

  def import_do
    if params[:file] 

      @stdout_stream = capture_stdout do
        importer_xls(params)
      end

      # Garder une trace dans un fichier de log
      if params[:enregistrer] == '1'
        f = File.new("log/import_#{DateTime.now}.log", 'w')
        f << @stdout_stream
        f.close
      end
    end
  end

  def importer_xls(params)

    # Enregistre le fichier localement (format = Date + nom du fichier)
    filename = DateTime.now.to_s.concat('-', params[:file].original_filename)

    # créer le répertoire temporaire s'ul n'existe pas déjà
    Dir.mkdir('public/excel') unless Dir.exist?('public/excel')

    file_with_path = Rails.root.join('public', 'excel', filename)
    File.open(file_with_path, 'wb') do |file|
      file.write(params[:file].read)
    end

    @importes = @errors = 0 
    @messages = []
    index = 1
    enregistrer = (params[:enregistrer] == '1')

    # IMPORT XLS
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open file_with_path
    sheet1 = book.worksheet 0
    headers = Compte.xls_headers
    
    organisation = current_user.organisation
    puts "Organisation: #{organisation.id} (#{organisation.nom})"

    sheet1.each 1 do |row|
      index += 1

      next unless row[0]

      # Structure => nom 
      structure = organisation
                  .structures
                  .where("UPPER(nom) = ?", row[headers.index 'structure'].strip.upcase)
                  .first_or_initialize do |s|
                    s.nom = row[headers.index 'structure']     
                  end

      @messages << message_import_log(structure)
      structure.save if structure.valid? && enregistrer

      # Compte => nom_compte civilité adresse1 adresse2 cp ville num_allocataire mémo_compte
      compte = structure
              .comptes
              .where('UPPER(nom) = ?', row[headers.index 'nom_compte'].strip.upcase)
              .first_or_initialize do |c|
                c.nom = row[headers.index 'nom_compte']
                c.civilité = row[headers.index 'civilité'] 
                c.adresse1 = row[headers.index 'adresse1'] 
                c.adresse2 = row[headers.index 'adresse2'] 
                c.cp = row[headers.index 'cp'].to_s 
                c.ville = row[headers.index 'ville'] 
                c.num_allocataire = row[headers.index 'num_allocataire'].to_s 
                c.mémo = row[headers.index 'mémo_compte']
              end

      @messages << message_import_log(compte)
      compte.save if compte.valid? && enregistrer 
              
      # Contact => nom_contact fixe portable email mémo_contact
      contact = compte
              .contacts
              .where('UPPER(nom) = ?', row[headers.index 'nom_contact'].strip.upcase)
              .first_or_initialize do |ct|
                ct.nom = row[headers.index 'nom_contact']
                ct.fixe = row[headers.index 'fixe']
                ct.portable = row[headers.index 'portable']
                ct.email = row[headers.index 'email']
                ct.mémo = row[headers.index 'mémo_contact'] 
              end

      @messages << message_import_log(contact)
      contact.save if contact.valid? && enregistrer 

        # Enfant => classroom nom_enfant prénom date_naissance menu_sp menu_all tarif_type badge
      enfant = compte
              .enfants
              .where('UPPER(nom) = ?', row[headers.index 'nom_enfant'].strip.upcase)
              .where('UPPER(prénom) = ?', row[headers.index 'prénom'].strip.upcase)
              .first_or_initialize do |e|
                e.nom = row[headers.index 'nom_enfant']
                e.prénom = row[headers.index 'prénom']
                e.classroom = organisation
                              .classrooms
                              .where(nom: row[headers.index 'classe'])
                              .first_or_create do |classe|
                                classe.nom = row[headers.index 'classe'] 
                              end
                e.date_naissance = row[headers.index 'date_naissance']              
                e.menu_sp = (row[headers.index 'menu_sp'].strip.upcase == 'OUI') 
                e.menu_all = (row[headers.index 'menu_all'].strip.upcase == 'OUI')
                e.tarif_type = organisation.tarif_types.find_by(nom: row[headers.index 'tarif_type'])
                e.badge = row[headers.index 'badge']
              end    
              
      @messages << message_import_log(enfant)
      enfant.save if enfant.valid? && enregistrer 
      
      # Réservations 
      # prestation_type début fin lundi mardi mercredi jeudi vendredi matin midi soir active hors_période_scolaire
      reservation = enfant
                    .reservations
                    .where(prestation_type: PrestationType.find_by(nom: row[headers.index 'prestation_type']))
                    .where(début: row[headers.index 'début'])
                    .where(fin: row[headers.index 'fin'])
                    .first_or_initialize do  |r|
                      r.prestation_type = PrestationType.find_by(nom: row[headers.index 'prestation_type'])
                      r.début = row[headers.index 'début']
                      r.fin = row[headers.index 'fin']
                      r.lundi = row[headers.index 'lundi'] 
                      r.mardi = row[headers.index 'mardi']
                      r.mercredi = row[headers.index 'mercredi']
                      r.jeudi = row[headers.index 'jeudi']
                      r.vendredi = row[headers.index 'vendredi']
                      r.matin = (row[headers.index 'matin'].strip.upcase == 'OUI')
                      r.midi = (row[headers.index 'midi'].strip.upcase == 'OUI')
                      r.soir = (row[headers.index 'soir'].strip.upcase == 'OUI')
                      r.active = (row[headers.index 'active'].strip.upcase == 'OUI')
                      r.hors_période_scolaire = (row[headers.index 'hors_période_scolaire'].strip.upcase == 'OUI')
                    end  

      @messages << message_import_log(reservation)
      reservation.save if reservation.valid? && enregistrer 

      (structure.valid? && compte.valid? && contact.valid? && enfant.valid? && reservation.valid?) ? @importes += 1 : @errors += 1 

      puts @messages
    end

    if @errors > 0
      puts "ERREUR ! #{@errors} lignes rejetées !"
    end 
  end

  def exemple_fichier_import_xls
    send_file ("public/Exemple_de_fichier_import.xls")
  end

  def envoyer_factures
    
  end

  def envoyer_factures_do
    envoyer = (params[:envoyer] == '1')

    organisation = current_user.organisation
    factures = organisation.factures.non_envoyées
    envoyées = 0

    @stdout_stream = capture_stdout do
      puts "Envoyer les factures?: #{envoyer}"

      factures.each do |f|
        email = f.compte.try(:contacts).first.try(:email)
        puts "Facture: #{f.réf} Compte: #{f.compte.nom}  => #{email ? email : "MANQUE ADRESSE EMAIL !!!"}"
      
        if email && envoyer
          mailer_response = FactureMailer.with(facture: f, to: email).envoyer_facture.deliver_now
          MailLog.create(organisation_id: current_user.organisation.id, message_id:mailer_response.message_id, to:email, subject: "Facture #{f.réf}")
          f.update(envoyée_le: DateTime.now)
          envoyées +=1
        end
      end
      puts "Total factures envoyées = #{envoyées}"
      puts "Consultez l'état des envois dans 'Administation/Mail Logs'"
    end
  end

  def mode_demonstration
    # ID OU EMAIL DU USER(1) À CHANGER AVANT DE RÉUTILISER CETTE FONCTION
    sign_in User.find(1)
    redirect_to comptes_url, notice: "Bienvenue dans la démonstration. Vous pouvez ici tester librement l'application. Merci d'en faire bon usage."
  end

  def dashboard
    @organisation = current_user.organisation

    compte_ids = @organisation.comptes.pluck(:id)
    @results = {}

    if compte_ids.any?
      @results = Facture
                .unscoped
                .where(compte_id: compte_ids)
                .where("factures.date BETWEEN ? AND ?", Date.today - 1.year, Date.today.beginning_of_month)
                .group("TO_CHAR(factures.date, 'YYYY-MM')")
                .sum(:montant)

      unless @results.keys.count == 12
        for i in 1..12 do
          key = (Date.today - i.months).strftime("%Y-%m")
          unless @results.key?(key)
            @results.store(key, 0)
          end
        end
      end
      @results = @results.sort_by { |key| key }.to_h

    end
  end

  def stats
    @organisations = Organisation.all.joins(:users).order('users.current_sign_in_at DESC NULLS LAST')
    @organisations = @organisations.page(params[:page]).per(50)
  end

private  
  def message_import_log(model)
    if model.valid? 
      "#{model.class.name.upcase} #{model.new_record? ? 'NOUVEAU' : 'MAJ'} => id:#{model.id} changements:#{model.changes}"
    else
      " !! ERREURS: " + model.errors.messages.map{|m| "#{m.first} => #{m.last}"}.join(',')
    end
  end

  def user_authorized?
    authorize :admin
  end
end
