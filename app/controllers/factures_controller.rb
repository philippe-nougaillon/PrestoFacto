class FacturesController < ApplicationController
  # on saute la sécurité si demande de facture PDF
  skip_before_action :authenticate_user!, only: [:show]

  before_action :set_facture, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /factures
  # GET /factures.json
  def index
    authorize Facture

    organisation = current_user.organisation
    @factures = organisation.factures
    @structures = organisation.structures

    unless params[:structure_id].blank?
      @factures = @factures.joins(:compte).where(comptes: { structure_id: params[:structure_id] })
    end

    unless params[:structure_id].blank?
      @factures = @factures.joins(:compte).where(comptes: { structure_id: params[:structure_id] })
    end

    unless params[:date_début].blank? || params[:date_fin].blank?
      @factures = @factures.where("DATE(date) BETWEEN ? AND ?", params[:date_début], params[:date_fin]) 
    end 

    unless params[:search].blank?
      @factures = @factures.joins(:compte).where("comptes.nom ILIKE ? OR factures.réf ILIKE ?", "%#{params[:search].upcase}%", "%#{params[:search].upcase}%")
    end 

    # Appliquer le tri
    @factures = @factures.reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @factures = @factures.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.xls do
        book = Facture.to_xls(@factures)
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Factures.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
  end

  # GET /factures/1
  # GET /factures/1.json
  def show
    authorize Facture

    respond_to do |format|
      format.html
      format.pdf do
        filename = "Facture_#{Date.today.to_s}"
        pdf = FacturePdf.new
        pdf.export_facture(@facture)

        send_data pdf.render,
            filename: filename.concat('.pdf'),
            type: 'application/pdf',
            disposition: 'inline'	
      end
    end
  end

  # GET /factures/new
  def new
    authorize Facture

    @facture = Facture.new
    @facture.compte_id = params[:compte_id]
    @prestation_types = current_user.organisation.prestation_types
    3.times{ @facture.facture_lignes.build }
  end

  # GET /factures/1/edit
  def edit
    authorize Facture

    @prestation_types = current_user.organisation.prestation_types
    1.times { @facture.facture_lignes.build }
  end

  # POST /factures
  # POST /factures.json
  def create
    authorize Facture

    @facture = Facture.new(facture_params)

    respond_to do |format|
      if @facture.save
        format.html { redirect_to @facture, notice: 'Facture créée' }
        format.json { render :show, status: :created, location: @facture }
      else
        format.html { render :new }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factures/1
  # PATCH/PUT /factures/1.json
  def update
    authorize Facture

    respond_to do |format|
      if @facture.update(facture_params)
        format.html { redirect_to @facture, notice: 'Facture modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @facture }
      else
        format.html { render :edit }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factures/1
  # DELETE /factures/1.json
  def destroy
    authorize Facture

    @facture.destroy
    respond_to do |format|
      format.html { redirect_to factures_url, notice: 'Facture supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facture
      #@facture = Facture.friendly.find(params[:id])
      @facture = Facture.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facture_params
      params.require(:facture).permit(:compte_id, :réf, :date, :échéance, :envoyée_le, :montant, :vérifiée, :mémo, :workflow_state,
                                        facture_lignes_attributes: [:id, :facture_id, :prestation_type_id, :intitulé, :qté, :prix, :total ,:_destroy])
    end

    def sortable_columns
      %w{structures.nom factures.réf factures.date factures.workflow_state comptes.nom factures.envoyée_le factures.montant factures.vérifiée factures.mémo}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'factures.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

end
