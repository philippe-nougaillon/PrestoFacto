class FacturesController < ApplicationController
  # on saute par dessus la sécurité si la demande est d'afficher une facture PDF
  skip_before_action :authenticate_user!, only: [:show]
  before_action :is_user_authorized, except: %i[ edit update destroy]

  before_action :set_facture, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /factures
  # GET /factures.json
  def index
    organisation = current_user.organisation
    @factures = organisation.factures
    @structures = organisation.structures

    unless params[:structure_id].blank?
      @factures = @factures.joins(:compte).where(comptes: { structure_id: params[:structure_id] })
    end

    unless params[:date_début].blank? || params[:date_fin].blank?
      @factures = @factures.where("DATE(date) BETWEEN ? AND ?", params[:date_début], params[:date_fin]) 
    end 

    unless params[:search].blank?
      s = "%#{params[:search].upcase}%"
      @factures = @factures.joins(:compte).where("comptes.nom ILIKE :search OR factures.réf ILIKE :search", {search: s})
    end 

    unless params[:state].blank?
      @factures = @factures.where("factures.workflow_state = ?", params[:state].to_s.downcase)
    end

    # Appliquer le tri
    @factures = @factures.reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    respond_to do |format|
      format.html do 
        @total_page = 0
        @total_factures = @factures.sum(:montant)
        @factures = @factures.page(params[:page])
      end
      
      format.xls do
        book = FacturesToXls.new(@factures).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Factures.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
  end

  def action
    return unless params[:factures_id]
    factures = Facture.where(id: params[:factures_id].keys)

    case params[:action_name]
    when "Passer à l'état 'vérifiée'"
      factures = factures.with_ajoutée_state.each do | f | 
        f.vérifier!
      end
      flash[:notice] = "#{factures.count} facture.s modifiée.s"  
    when "Envoyer"
      factures = factures.with_vérifiée_state.each do | f |
        email = f.compte.try(:contacts).first.try(:email)
        # Envoyer la facture
        mailer_response = FactureMailer.with(facture: f, to: email).envoyer_facture.deliver_now
        MailLog.create(organisation_id: current_user.organisation.id, message_id:mailer_response.message_id, to:email, subject: "Facture #{f.réf}")

        # Mise à jour de la date d'envoi
        f.update(envoyée_le: DateTime.now)
        f.envoyer!
      end
      flash[:notice] = "#{factures.count} facture.s envoyée.s. Consultez l'état des envoies dans 'Administation/Mail Logs'"  
    end

    redirect_to factures_url
  end

  # GET /factures/1
  # GET /factures/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        if @facture
          filename = "Facture_#{Date.today.to_s}"
          pdf = FacturePdf.new
          pdf.export_facture(@facture)

          send_data pdf.render,
              filename: filename.concat('.pdf'),
              type: 'application/pdf',
              disposition: 'inline'	
        else
          redirect_to root_url, alert: 'Oups! Cette facture est introuvable...'
        end
      end
    end
  end

  # GET /factures/new
  def new
    @facture = Facture.new
    @facture.compte_id = params[:compte_id]
    @facture.date = Date.today
    @prestation_types = current_user.organisation.prestation_types
    1.times{ @facture.facture_lignes.build }
  end

  # GET /factures/1/edit
  def edit
    authorize @facture

    @prestation_types = current_user.organisation.prestation_types
    1.times { @facture.facture_lignes.build }
  end

  # POST /factures
  # POST /factures.json
  def create
    @facture = Facture.new(facture_params)
    @prestation_types = current_user.organisation.prestation_types

    respond_to do |format|
      if @facture.save
        update_total(@facture)
        format.html { redirect_to @facture, notice: 'Facture créée' }
        format.json { render :show, status: :created, location: @facture }
      else
        format.html { render :new }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factures/1
  # PATCH/PUT /factures/1.json
  def update
    authorize @facture

    @prestation_types = current_user.organisation.prestation_types

    respond_to do |format|
      if @facture.update(facture_params)
        update_total(@facture)
        format.html { redirect_to @facture, notice: 'Facture modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @facture }
      else
        format.html { render :edit }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factures/1
  # DELETE /factures/1.json
  def destroy
    authorize @facture

    @facture.destroy
    respond_to do |format|
      format.html { redirect_to factures_url, notice: 'Facture supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facture
      @facture = Facture.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facture_params
      params.require(:facture)
            .permit(:compte_id, :réf, :date, :échéance, :envoyée_le, :montant, :vérifiée, :mémo, :workflow_state, 
                    facture_lignes_attributes: [:id, :facture_id, :prestation_type_id, :intitulé, :qté, :prix, :total ,:_destroy])
    end

    def sortable_columns
      %w{structures.nom factures.réf factures.date factures.workflow_state comptes.nom factures.envoyée_le factures.montant factures.vérifiée factures.mémo}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'factures.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def is_user_authorized
      authorize Facture
    end

    def update_total(facture)
      facture.facture_lignes.each do |facture_ligne|
        facture_ligne.update(total: facture_ligne.prix * facture_ligne.qté)
      end
      facture.update(montant: facture.facture_lignes.sum(:total))
    end

end
