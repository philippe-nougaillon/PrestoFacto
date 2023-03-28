class StructuresController < ApplicationController
  before_action :set_structure, only: [:show, :edit, :update, :destroy]

  # GET /structures/1
  # GET /structures/1.json
  def show
    authorize @structure
  end

  # GET /structures/1/edit
  def edit
    authorize @structure
  end

  # PATCH/PUT /structures/1
  # PATCH/PUT /structures/1.json
  def update
    authorize @structure
    
    respond_to do |format|
      if @structure.update(structure_params)
        format.html { redirect_to @structure, notice: 'Structure modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @structure }
      else
        format.html { render :edit }
        format.json { render json: @structure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /structures/1
  # DELETE /structures/1.json
  def destroy
    authorize @structure

    @structure.destroy
    respond_to do |format|
      format.html { redirect_to current_user.organisation, notice: 'Structure supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_structure
      @structure = Structure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def structure_params
      params.require(:structure).permit(:organisation_id, :nom, :adresse, :cp, :ville,
                                          classrooms_attributes: [:id, :nom, :référent, :_destroy])
    end
end
