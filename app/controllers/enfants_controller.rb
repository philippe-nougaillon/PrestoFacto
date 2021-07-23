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
      @enfants = @enfants.joins(:compte).where(comptes: { structure_id: params[:structure_id] })
      @classrooms = @classrooms.where(structure_id: params[:structure_id])      
    end

    unless params[:classroom_id].blank?
      @enfants = @enfants.where(classroom_id: params[:classroom_id])      
    end
    
    unless params[:nom].blank?
      s = "'%#{params[:nom]}%'"
      @enfants = @enfants.where(Arel.sql("enfants.nom ILIKE #{s} OR enfants.prénom ILIKE #{s}"))
    end

    # Appliquer le tri
    @enfants = @enfants.reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    # Découper le résultat en pages
    @enfants = @enfants.page(params[:page])  
  end

  # GET /enfants/1
  # GET /enfants/1.json
  def show
    authorize @enfant
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
    authorize Enfant

    1.times { @enfant.reservations.build(début: Date.today) }
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
    authorize Enfant

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
    authorize Enfant

    begin
      @enfant.destroy
    rescue ActiveRecord::InvalidForeignKey
      redirect_to enfants_url, alert: "L'enfant ne peut pas être supprimé pour le moment car des éléments liés existent. Veuillez d'abord supprimer ces éléments liés (Réservations/Absences...) avant de retenter l'opération."
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
            .permit(:compte_id, :classroom_id, :nom, :prénom, :date_naissance, :menu_sp, :menu_all, :allergenes, :tarif_type_id, :badge, :mémo,
                    reservations_attributes: [:id, :enfant_id, :prestation_type_id, :workflow_state,
                                              :début, :fin, 
                                              :lundi, :mardi, :mercredi, :jeudi, :vendredi, 
                                              :matin, :midi, :soir, :hors_période_scolaire, :_destroy])
    end

    def sortable_columns
      %w{structures.nom comptes.nom classrooms.nom comptes.nom enfants.nom enfants.prénom enfants.date_naissance enfants.menu_sp enfants.menu_all}
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
