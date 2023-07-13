class PointagesController < ApplicationController
  before_action :set_pointage, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /pointages or /pointages.json
  def index
    params[:date] ||= Date.today

    @pointages = Pointage.all
    organisation = current_user.organisation
    @prestation_types = organisation.prestation_types.where(forfaitaire: false).order(:nom)

    unless params[:date].blank?
      @pointages = @pointages.where(date_pointage: params[:date])
    end
    unless params[:prestation_type_id].blank?
      @pointages = @pointages.where(prestation_type_id: params[:prestation_type_id]) 
    end
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
end
