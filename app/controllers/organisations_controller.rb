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

    unless ['pierre-emmanuel.dacquet@aikku.eu', 'philippe.nougaillon@aikku.eu', 'sebastien.pourchaire@aikku.eu'].include?(current_user.email)
      AdminMailer.with(organisation: @organisation, reason: params[:reason]).suppression_organisation_notification.deliver_now
    end

    @organisation.structures.each do |structure|
      structure.classrooms.each do |classroom|
        classroom.enfants.each do |enfant|
          enfant.prestations.destroy_all
          enfant.reservations.destroy_all
          enfant.absences.destroy_all
        end
        classroom.enfants.destroy_all
      end
      structure.classrooms.destroy_all
    end

    @organisation.comptes.each do |compte|
      compte.factures.destroy_all
      compte.paiements.destroy_all
    end

    @organisation.tarif_types.each do |tarif_type|
      tarif_type.tarifs.destroy_all
    end

    @organisation.structures.destroy_all
    @organisation.vacances.destroy_all
    @organisation.facture_messages.destroy_all
    @organisation.facture_chronos.destroy_all
    @organisation.comptes.destroy_all
    @organisation.prestation_types.destroy_all
    @organisation.tarif_types.destroy_all
    @organisation.users.destroy_all

    MailLog.where(organisation_id: @organisation.id).destroy_all

    @organisation.destroy

    if ['pierre-emmanuel.dacquet@aikku.eu', 'philippe.nougaillon@aikku.eu', 'sebastien.pourchaire@aikku.eu'].include?(current_user.email)
      respond_to do |format|
        format.html { redirect_to admin_stats_path }
        format.json { head :no_content }
      end
    else
      sign_out

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Tout a bien été supprimé. En espérant vous revoir prochainement :)" }
        format.json { head :no_content }
      end
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
