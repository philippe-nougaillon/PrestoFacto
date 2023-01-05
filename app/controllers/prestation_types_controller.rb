class PrestationTypesController < ApplicationController
  before_action :set_prestation_type, only: [ :edit, :update, :destroy]

  # GET /prestation_types/new
  def new
    authorize PrestationType

    @prestation_type = PrestationType.new
    @prestation_type.organisation_id = params[:organisation_id]
  end

  # GET /prestation_types/1/edit
  def edit
    authorize @prestation_type
  end

  # POST /prestation_types
  # POST /prestation_types.json
  def create
    authorize PrestationType

    @prestation_type = PrestationType.new(prestation_type_params)

    respond_to do |format|
      if @prestation_type.save
        format.html { redirect_to admin_tarifs_path, notice: 'Prestation type créée avec succès.' }
        format.json { render :show, status: :created, location: @prestation_type }
      else
        format.html { redirect_to admin_tarifs_path, alert: @prestation_type.errors}
        format.json { render json: @prestation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prestation_types/1
  # PATCH/PUT /prestation_types/1.json
  def update
    authorize @prestation_type

    respond_to do |format|
      if @prestation_type.update(prestation_type_params)
        format.html { redirect_to admin_tarifs_path, notice: 'Prestation type modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @prestation_type }
      else
        format.html { render :edit }
        format.json { render json: @prestation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestation_types/1
  # DELETE /prestation_types/1.json
  def destroy
    authorize @prestation_type

    @prestation_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_tarifs_path, notice: 'Prestation type supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prestation_type
      @prestation_type = PrestationType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prestation_type_params
      params.require(:prestation_type).permit(:organisation_id, :nom)
    end
end
