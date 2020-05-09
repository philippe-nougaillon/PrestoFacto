class TarifsController < ApplicationController
  before_action :set_tarif, only: [:show, :edit, :update, :destroy]

  # GET /tarifs
  # GET /tarifs.json
  def index
    @tarifs = Tarif.all
  end

  # GET /tarifs/1
  # GET /tarifs/1.json
  def show
  end

  # GET /tarifs/new
  def new
    @tarif = Tarif.new
  end

  # GET /tarifs/1/edit
  def edit
  end

  # POST /tarifs
  # POST /tarifs.jsonNouveau Tarif
  def create
    authorize Tarif

    @tarif = Tarif.new(tarif_params)

    respond_to do |format|
      if @tarif.save
        format.html { redirect_to admin_tarifs_path, notice: 'Tarif créé.e avec succès.' }
        format.json { render :show, status: :created, location: @tarif }
      else
        format.html { redirect_to admin_tarifs_path, alert: @tarif.errors }
        format.json { render json: @tarif.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tarifs/1
  # PATCH/PUT /tarifs/1.json
  def update
    authorize Tarif 

    respond_to do |format|
      if @tarif.update(tarif_params)
        format.html { redirect_to admin_tarifs_path, notice: 'Tarif modifié.e avec succès.' }
        format.json { render :show, status: :ok, location: @tarif }
      else
        format.html { redirect_to admin_tarifs_path, alert: @tarif.error }
        format.json { render json: @tarif.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tarifs/1
  # DELETE /tarifs/1.json
  def destroy
    authorize @tarif

    @tarif.destroy
    respond_to do |format|
      format.html { redirect_to admin_tarifs_path, notice: 'Tarif supprimé.e avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tarif
      @tarif = Tarif.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tarif_params
      params.require(:tarif).permit(:tarif_type_id, :prestation_type_id, :prix)
    end
end
