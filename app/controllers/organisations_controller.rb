class OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :edit, :update, :destroy]

  # GET /organisations
  # GET /organisations.json
  def index
    authorize Organisation
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    authorize @organisation
  end

  # GET /organisations/new
  def new
    authorize Organisation

    @organisation = Organisation.new
    3.times { @organisation.structures.build }
  end

  # GET /organisations/1/edit
  def edit
    authorize @organisation

    1.times { @organisation.structures.build }
  end

  # POST /organisations
  # POST /organisations.json
  def create
    authorize Organisation

    @organisation = Organisation.new(organisation_params)

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to @organisation, notice: 'Organisation créé.e avec succès.' }
        format.json { render :show, status: :created, location: @organisation }
      else
        format.html { render :new }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organisations/1
  # PATCH/PUT /organisations/1.json
  def update
    authorize @organisation

    respond_to do |format|
      if @organisation.update(organisation_params)
        format.html { redirect_to @organisation, notice: 'Organisation modifié.e avec succès.' }
        format.json { render :show, status: :ok, location: @organisation }
      else
        format.html { render :edit }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    authorize Organisation

    # @organisation.destroy
    respond_to do |format|
      format.html { redirect_to organisations_url, notice: 'Organisation supprimé.e avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organisation_params
      params.require(:organisation).permit(:nom, :adresse, :cp, :ville, :téléphone, :email, :logo, :zone,
                                            structures_attributes: [:id, :nom, :_destroy])
    end
end
