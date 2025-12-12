class EnfantsController < ApplicationController
  before_action :set_enfant, only: [:show, :edit, :update, :destroy]
  before_action :populate_select, only: [:new, :edit]
  
  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_child

  # GET /enfants
  # GET /enfants.json
  def index
    authorize Enfant

    organisation = current_user.organisation
    @enfants = organisation.enfants
    @structures = organisation.structures
    @classrooms = organisation.classrooms

    unless params[:structure_id].blank?
      @enfants = @enfants.joins(:classroom).where(classrooms: { structure_id: params[:structure_id] })
      @classrooms = @classrooms.where(structure_id: params[:structure_id])      
    end

    unless params[:classroom_id].blank?
      @enfants = @enfants.where(classroom_id: params[:classroom_id])      
    end
    
    unless params[:search].blank?
      s = "%#{params[:search].upcase}%"
      @enfants = @enfants.where('enfants.nom ILIKE :search OR enfants.prénom ILIKE :search OR enfants.badge ILIKE :search', {search: s})
    end

    # Appliquer le tri
    @enfants = @enfants.joins(:compte).reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    respond_to do |format|
      format.html do 
        @enfants = @enfants.page(params[:page])
      end
      format.xls do
        book = ComptesToXls.new(Compte.where(id: @enfants.pluck(:compte_id))).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Enfants.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
  end

  def action
    return unless params[:enfants_id]
    enfants = Enfant.where(id: params[:enfants_id].keys)

    case params[:action_name]
    when "Marquer comme absent ce jour"
      enfants = enfants.each do | enfant | 
        enfant.absences.create(début: Date.today, fin: Date.today)
      end
      flash[:notice] = "#{enfants.count} absence.s créée.s" 
      redirect_to enfants_url
    when "Changer de classe"
    end

  end

  def action_execute
    return unless params[:enfants_id]
    enfants = Enfant.where(id: params[:enfants_id].split(' '))

    enfants = enfants.each do | enfant | 
      enfant.classroom_id = params[:classroom_id]
      enfant.save
    end
    flash[:notice] = "#{enfants.count} enfants déplacé.e.s" 
    redirect_to enfants_url
  end

  # GET /enfants/1
  # GET /enfants/1.json
  def show
    authorize @enfant
    if params[:archives] == 'yes'
      @absences = @enfant.absences.unscoped
    else
      @absences = @enfant.absences
    end
  end

  # GET /enfants/new
  def new
    authorize Enfant

    @enfant = Enfant.new
    @enfant.compte = Compte.friendly.find(params[:compte_id]) 
    
    # Valeurs par défaut de la réservation

    @enfant.reservations
              .build(début: @enfant.organisation.vacances_été.fin , 
                    fin: @enfant.organisation.vacances_été.début + 1.year, 
                    lundi: 1, mardi: 1, mercredi: 1, jeudi: 1, vendredi: 1, midi: true, 
                    workflow_state: 'validée')
  end

  # GET /enfants/1/edit
  def edit
    authorize @enfant
  end

  # POST /enfants
  # POST /enfants.json
  def create
    authorize Enfant

    @enfant = Enfant.new(enfant_params)
    respond_to do |format|
      if @enfant.save
        format.html { redirect_to @enfant, notice: 'Enfant créé avec succès.' }
        format.json { render :show, status: :created, location: @enfant }
      else
        format.html { render :new }
        format.json { render json: @enfant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enfants/1
  # PATCH/PUT /enfants/1.json
  def update
    authorize @enfant

    respond_to do |format|
      if @enfant.update(enfant_params)
        format.html { redirect_to @enfant, notice: 'Enfant modifié avec succès.' }
        format.json { render :show, status: :ok, location: @enfant }
      else
        format.html { render :edit }
        format.json { render json: @enfant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enfants/1
  # DELETE /enfants/1.json
  def destroy
    authorize @enfant

    begin
      @enfant.destroy
    rescue ActiveRecord::InvalidForeignKey => exception
      #redirect_to enfants_url, alert: "L'enfant ne peut pas être supprimé pour le moment car des éléments liés existent. Veuillez d'abord supprimer ces éléments liés (Réservations/Absences...) avant de retenter l'opération."
      redirect_to enfants_url, alert: exception
      return
    end

    respond_to do |format|
      format.html { redirect_to enfants_url, notice: 'Enfant supprimé avec succès.' }
      format.json { head :no_content }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enfant
      @enfant = Enfant.friendly.find(params[:id])
    end

    def populate_select
      @classrooms = current_user.organisation.classrooms
      @tarif_types = current_user.organisation.tarif_types
      @prestation_types = current_user.organisation.prestation_types
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enfant_params
      params.require(:enfant)
            .permit(:compte_id, :classroom_id, :nom, :prénom, :date_naissance, :menu_vege, :menu_sp, :menu_all, :allergenes, :tarif_type_id, :badge, :mémo,
                    reservations_attributes: [:id, :enfant_id, :prestation_type_id, :workflow_state,
                                              :début, :fin, 
                                              :lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche,
                                              :matin, :midi, :soir, :hors_période_scolaire, :_destroy])
    end

    def sortable_columns
      %w{structures.nom comptes.nom classrooms.nom comptes.nom enfants.nom enfants.prénom enfants.date_naissance enfants.menu_sp enfants.menu_all enfants.menu_vege}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'enfants.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

    def invalid_child
      redirect_to enfants_url
    end

end
