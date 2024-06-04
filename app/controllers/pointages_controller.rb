class PointagesController < ApplicationController
  before_action :set_pointage, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  helper_method :sort_column, :sort_direction

  # GET /pointages or /pointages.json
  def index
    params[:date] ||= Date.today

    @pointages = Pointage.all
    organisation = current_user.organisation
    @prestation_types = organisation.prestation_types.where(forfaitaire: false).order(:nom)
    @classrooms = organisation.classrooms

    unless params[:date].blank?
      @pointages = @pointages.where(date_pointage: params[:date])
    end
    unless params[:prestation_type_id].blank?
      @pointages = @pointages.where(prestation_type_id: params[:prestation_type_id]) 
    end
    unless params[:classroom_id].blank?
      @pointages = @pointages.joins(:enfant).where(enfants: {classroom_id: params[:classroom_id]})
    end

    # Appliquer le tri
    @pointages = @pointages.joins(:enfant).joins(:prestation_type).reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @pointages = @pointages.page(params[:page])
  end

  # GET /pointages/1 or /pointages/1.json
  def show
  end

  # GET /pointages/new
  def new
    @pointage = Pointage.new
  end

  # GET /pointages/1/edit
  def edit
  end

  # POST /pointages or /pointages.json
  def create
    @pointage = Pointage.new(pointage_params)

    respond_to do |format|
      if @pointage.save
        format.html { redirect_to pointage_url(@pointage), notice: "Pointage a été créé avec succès." }
        format.json { render :show, status: :created, location: @pointage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pointage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pointages/1 or /pointages/1.json
  def update
    respond_to do |format|
      if @pointage.update(pointage_params)
        format.html { redirect_to pointage_url(@pointage), notice: "Pointage a été modifié avec succès." }
        format.json { render :show, status: :ok, location: @pointage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pointage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pointages/1 or /pointages/1.json
  def destroy
    @pointage.destroy

    respond_to do |format|
      format.html { redirect_to pointages_url, notice: "Pointage a été supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  def action
    return unless params[:pointages_id]
    pointages = Pointage.where(id: params[:pointages_id].keys)
    pointages_count = pointages.count

    case params[:action_name]
    when "Pointer les arrivées/départs à l'instant T"
      pointages.each do | pointage | 
        pointage.heure_pointage = DateTime.now + 2.hour
        pointage.save
      end
      flash[:notice] = "#{pointages_count} pointages.s réalisé.s" 
      redirect_to pointages_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pointage
      @pointage = Pointage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pointage_params
      params.require(:pointage).permit(:heure_pointage)
    end

    def is_user_authorized
      authorize Pointage
    end

    def sortable_columns
      %w{enfants.nom prestation_types.nom pointages.date_pointage pointages.heure_pointage pointages.updated_at}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'enfants.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
