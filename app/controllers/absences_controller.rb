class AbsencesController < ApplicationController
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :is_user_authorized, except: %i[show edit update destroy]

  # GET /absences
  # GET /absences.json
  def index
    params[:date] ||= Date.today

    organisation = current_user.organisation
    @absences = organisation.absences
    @structures = organisation.structures
    @classrooms = organisation.classrooms

    unless params[:archives].blank?
      @absences = organisation.absences.unscoped.where(archive: true)
    end

    unless (params[:date].blank? || params[:date] == 'full')
      @absences = @absences.where("DATE(?) BETWEEN début AND fin", params[:date])
    end

    unless params[:structure_id].blank?
      @absences = @absences.joins(enfant: [:compte]).where(comptes: { structure_id: params[:structure_id] })
      @classrooms = @classrooms.where(structure_id: params[:structure_id]) 
    end

    unless params[:classroom_id].blank?
      @absences = @absences.joins(:enfant).where(enfants: { classroom_id: params[:classroom_id] })      
    end

    unless params[:nom].blank?
      @absences = @absences.joins(:enfant).where("enfants.nom ILIKE ? OR enfants.prénom ILIKE ?", "%#{params[:nom]}%", "%#{params[:nom]}%")
    end

    # Appliquer le tri
    @absences = @absences.joins(:enfant => :classroom).reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @absences = @absences.page(params[:page])
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    authorize @absence
  end

  # GET /absences/new
  def new
    @absence = Absence.new
    @absence.enfant_id = params[:enfant_id]
  end

  # GET /absences/1/edit
  def edit
    authorize @absence
  end

  # POST /absences
  # POST /absences.json
  def create
    @absence = Absence.new(absence_params)

    respond_to do |format|
      if @absence.save
        format.html { redirect_to @absence.enfant, notice: 'Absence créée avec succès.' }
        format.json { render :show, status: :created, location: @absence }
      else
        format.html { render :new }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absences/1
  # PATCH/PUT /absences/1.json
  def update
    authorize @absence

    respond_to do |format|
      if @absence.update(absence_params)
        format.html { redirect_to @absence, notice: 'Absence modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @absence }
      else
        format.html { render :edit }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    authorize @absence

    @absence.destroy
    respond_to do |format|
      format.html { redirect_to absences_url, notice: 'Absence supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_absence
      @absence = Absence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def absence_params
      params.require(:absence).permit(:enfant_id, :début, :fin, :matin, :midi, :soir)
    end

    def sortable_columns
      %w{structures.nom enfants.nom classrooms.nom absences.début absences.fin}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'absences.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

    def is_user_authorized
      authorize Absence
    end

end
