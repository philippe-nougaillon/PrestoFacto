class PaiementsController < ApplicationController
  before_action :set_paiement, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /paiements
  # GET /paiements.json
  def index
    authorize Paiement

    @paiements = current_user.organisation.paiements
    @structures = current_user.organisation.structures

    unless params[:structure_id].blank?
      @paiements = @paiements.joins(:compte).where(comptes: { structure_id: params[:structure_id] })
    end

    unless params[:date_début].blank? || params[:date_fin].blank?
      @paiements = @paiements.where("DATE(date) BETWEEN ? AND ?", params[:date_début], params[:date_fin]) 
    end 

    unless params[:mode].blank?
      @paiements = @paiements.where(mode: params[:mode])
    end

    unless params[:nom].blank?
      @paiements = @paiements.joins(:compte).where("comptes.nom ILIKE ? OR paiements.réf like ?", "%#{params[:nom]}%", "%#{params[:nom].upcase}%") 
    end

    # Appliquer le tri
    @paiements = @paiements.reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @paiements = @paiements.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.xls do
        book = Paiement.to_xls(@paiements)
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Paiements.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
  end

  # GET /paiements/1
  # GET /paiements/1.json
  def show
    authorize @paiement
  end

  # GET /paiements/new
  def new
    authorize Paiement

    @paiement = Paiement.new
    @paiement.compte_id = params[:compte_id]
    @paiement.date = Date.today
  end

  # GET /paiements/1/edit
  def edit
    authorize Paiement
  end

  # POST /paiements
  # POST /paiements.json
  def create
    authorize Paiement

    @paiement = Paiement.new(paiement_params)

    respond_to do |format|
      if @paiement.save
        format.html { redirect_to @paiement.compte, notice: 'Paiement a été créé avec succès.' }
        format.json { render :show, status: :created, location: @paiement }
      else
        format.html { render :new }
        format.json { render json: @paiement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paiements/1
  # PATCH/PUT /paiements/1.json
  def update
    authorize Paiement

    respond_to do |format|
      if @paiement.update(paiement_params)
        format.html { redirect_to @paiement, notice: 'Paiement modifié avec succès.' }
        format.json { render :show, status: :ok, location: @paiement }
      else
        format.html { render :edit }
        format.json { render json: @paiement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paiements/1
  # DELETE /paiements/1.json
  def destroy
    authorize Paiement

    @paiement.destroy
    respond_to do |format|
      format.html { redirect_to paiements_url, notice: 'Paiement détruit !' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paiement
      @paiement = Paiement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paiement_params
      params.require(:paiement).permit(:compte_id, :date, :réf, :mode, :banque, :chèque_num, :montant, :date_remise, :mémo)
    end

    def sortable_columns
      %w{structures.nom paiements.réf paiements.date comptes.nom paiements.montant paiements.mémo paiements.date_remise paiements.mode paiements.banque paiements.chèque_num}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'paiements.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

end
