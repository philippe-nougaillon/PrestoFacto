class PrestationsController < ApplicationController
  before_action :set_prestation, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def index
    authorize Prestation

    # params[:date] ||= Date.today

    organisation = current_user.organisation  
    @structures = organisation.structures
    @classrooms = organisation.classrooms
    @prestation_types = organisation.prestation_types
    @prestations = organisation.prestations
    
    unless params[:structure_id].blank?
      @prestations = @prestations.joins(enfant: [:compte]).where(comptes: { structure_id: params[:structure_id] })
      @classrooms = @classrooms.where(structure_id: params[:structure_id]) 
    end

    unless params[:classroom_id].blank?
      @prestations = @prestations.joins(:enfant).where(enfants: { classroom_id: params[:classroom_id] })      
    end

    unless params[:prestation_type_id].blank?
      @prestations = @prestations.where(prestation_type_id: params[:prestation_type_id]) 
    end
    
    unless params[:date].blank?
      @prestations = @prestations.where(date: params[:date]) 
    end 

    unless params[:nom].blank?
      @prestations = @prestations.joins(:enfant).where("enfants.nom ILIKE ? OR enfants.prénom ILIKE ?", "%#{params[:nom]}%", "%#{params[:nom]}%") 
    end 

    # Appliquer le tri
    @prestations = @prestations.joins(:enfant => :classroom)
                               .joins(:prestation_type)
                               .reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @prestations = @prestations.paginate(page: params[:page])
  end

  def show
    authorize Prestation
  end

  # GET /prestations/1/edit
  def edit
    authorize Prestation

    @prestation_types = current_user.organisation.prestation_types
  end

  # POST /prestations
  # POST /prestations.json
  def create
    authorize Prestation
  end

  # PATCH/PUT /prestations/1
  # PATCH/PUT /prestations/1.json
  def update
    authorize Prestation

    respond_to do |format|
      if @prestation.update(prestation_params)
        format.html { redirect_to prestations_url, notice: 'Prestation modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @prestation }
      else
        format.html { render :edit }
        format.json { render json: @prestation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestations/1
  # DELETE /prestations/1.json
  def destroy
    authorize Prestation

    @prestation.destroy
    respond_to do |format|
      format.html { redirect_to prestations_url, notice: 'Prestation supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prestation
      @prestation = Prestation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prestation_params
      params.require(:prestation).permit(:qté)
    end

    def sortable_columns
      %w{structures.nom prestations.date prestation_types.nom enfants.nom enfants.prénom classrooms.nom prestations.qté}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'prestations.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

end
