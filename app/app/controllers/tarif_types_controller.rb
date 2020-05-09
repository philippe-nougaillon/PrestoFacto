class TarifTypesController < ApplicationController
  before_action :set_tarif_type, only: [:show, :edit, :update, :destroy]

  # GET /tarif_types
  # GET /tarif_types.json
  def index
    authorize TarifType

    @tarif_types = TarifType.all
  end

  # GET /tarif_types/1
  # GET /tarif_types/1.json
  def show
    authorize TarifType
  end

  # GET /tarif_types/new
  def new
    authorize TarifType

    @tarif_type = TarifType.new
    @tarif_type.organisation_id = params[:organisation_id]
  end

  # GET /tarif_types/1/edit
  def edit
    authorize TarifType
  end

  # POST /tarif_types
  # POST /tarif_types.json
  def create
    authorize TarifType

    @tarif_type = TarifType.new(tarif_type_params)

    respond_to do |format|
      if @tarif_type.save
        format.html { redirect_to admin_tarifs_path, notice: 'Tarif type créé.e avec succès.' }
        format.json { render :show, status: :created, location: @tarif_type }
      else
        format.html { redirect_to admin_tarifs_path, alert: @tarif_type.errors }
        format.json { render json: @tarif_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tarif_types/1
  # PATCH/PUT /tarif_types/1.json
  def update
    authorize TarifType

    respond_to do |format|
      if @tarif_type.update(tarif_type_params)
        format.html { redirect_to admin_tarifs_path, notice: 'Tarif type modifié.e avec succès.' }
        format.json { render :show, status: :ok, location: @tarif_type }
      else
        format.html { render :edit }
        format.json { render json: @tarif_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tarif_types/1
  # DELETE /tarif_types/1.json
  def destroy
    authorize @tarif_type

    @tarif_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_tarifs_path, notice: 'Tarif type supprimé.e avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tarif_type
      @tarif_type = TarifType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tarif_type_params
      params.require(:tarif_type).permit(:organisation_id, :nom)
    end
end
