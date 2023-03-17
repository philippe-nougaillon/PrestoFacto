class OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :edit, :update, :destroy, :suppression_organisation, :suppression_organisation_do]

  # GET /organisations
  # GET /organisations.json
  def index
    authorize Organisation
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    authorize @organisation
    @vacances = Vacance.where(zone: @organisation.zone)
                       .or(Vacance.where(organisation_id: @organisation.id))
                       .where("DATE(fin) >= ?", Date.today)
  end

  # GET /organisations/new
  def new
    authorize Organisation

    @organisation = Organisation.new
    1.times { @organisation.structures.build }
  end

  # GET /organisations/1/edit
  def edit
    authorize @organisation

    1.times { @organisation.vacances.build }
  end

  # POST /organisations
  # POST /organisations.json
  def create
    authorize Organisation

    @organisation = Organisation.new(organisation_params)

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to @organisation, notice: 'Organisation créée avec succès.' }
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
        format.html { redirect_to @organisation, notice: 'Organisation modifiée avec succès.' }
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

    @organisation.mail_logs.destroy
    # @organisation.destroy
    respond_to do |format|
      format.html { redirect_to organisations_url, notice: 'Organisation supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  def suppression_organisation
    authorize @organisation
  end

  def suppression_organisation_do
    authorize @organisation

    @organisation.facture_messages.delete_all
    @organisation.structures.delete_all
    @organisation.users.delete_all
    @organisation.vacances.delete_all
    @organisation.facture_messages.delete_all
    @organisation.facture_chronos.delete_all
    @organisation.comptes.delete_all
    @organisation.prestation_types.delete_all
    @organisation.tarif_types.delete_all

    @organisation.classrooms.delete_all
    @organisation.enfants.delete_all
    @organisation.factures.delete_all
    @organisation.paiements.delete_all
    @organisation.prestations.delete_all
    @organisation.reservations.delete_all
    @organisation.absences.delete_all
    @organisation.tarifs.delete_all

    @organisation.delete

    session[:current_user] = nil

    respond_to do |format|
      format.html { redirect_to root_path, notice: "fiaoai" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organisation
      @organisation = Organisation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organisation_params
      params.require(:organisation).permit(:nom, :adresse, :cp, :ville, :téléphone, :email, :logo, :zone,
                                            structures_attributes: [:id, :nom, :_destroy],
                                            vacances_attributes: [:id, :zone, :nom, :début, :fin])
    end
end
