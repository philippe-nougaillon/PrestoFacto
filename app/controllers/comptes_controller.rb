class ComptesController < ApplicationController
  before_action :set_compte, only: [:show, :balance, :edit, :update, :destroy]
  before_action :calcul_solde_balance, only: [:show, :balance]

  helper_method :sort_column, :sort_direction

  # GET /comptes
  # GET /comptes.json
  def index
    authorize Compte

    @comptes = current_user.organisation.comptes
    @structures = current_user.organisation.structures
    
    unless params[:structure_id].blank?
      @comptes = @comptes.where(structure_id: params[:structure_id])
    end

    unless params[:search].blank?
      s = "'%#{ params[:search] }%'"
      @comptes = @comptes.joins(:enfants)
                          .where(Arel.sql("enfants.badge ILIKE #{ s } OR enfants.prénom ILIKE #{ s } OR comptes.nom ILIKE #{ s } OR comptes.cp ILIKE #{ s } OR comptes.ville ILIKE #{ s } OR comptes.num_allocataire ILIKE #{ s }"))
    end

    # Appliquer le tri
    @comptes = @comptes.reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    # Découper le résultat en pages
    @comptes = @comptes.paginate(page: params[:page])
  end

  # GET /comptes/1
  # GET /comptes/1.json
  def show
    authorize @compte
  end

  def balance
    authorize (Compte)

    @releve = @compte.balance
  end

  # GET /comptes/new
  def new
    authorize Compte
    
    @compte = Compte.new
    @compte.organisation = current_user.organisation
    
    3.times { @compte.contacts.build }
  end

  # GET /comptes/1/edit
  def edit
    authorize Compte
    
    @structures = current_user.organisation.structures
    3.times { @compte.contacts.build }
  end

  # POST /comptes
  # POST /comptes.json
  def create
    authorize Compte
    
    @compte = Compte.new(compte_params)

    respond_to do |format|
      if @compte.save
        format.html { redirect_to @compte, notice: 'Compte créé avec succès.' }
        format.json { render :show, status: :created, location: @compte }
      else
        format.html { render :new }
        format.json { render json: @compte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comptes/1
  # PATCH/PUT /comptes/1.json
  def update
    authorize Compte

    respond_to do |format|
      if @compte.update(compte_params)
        format.html { redirect_to @compte, notice: 'Compte modifié avec succès.' }
        format.json { render :show, status: :ok, location: @compte }
      else
        format.html { render :edit }
        format.json { render json: @compte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comptes/1
  # DELETE /comptes/1.json
  def destroy
    authorize Compte

    begin
      @compte.destroy
    rescue ActiveRecord::InvalidForeignKey
      redirect_to comptes_url, alert: "Le compte ne peut pas être supprimé pour le moment car des éléments liés existent. Veuillez d'abord supprimer ces éléments liés (Enfants/Factures...) avant de retenter l'opération."
      return
    end
    
    respond_to do |format|
      format.html { redirect_to comptes_url, notice: 'Compte supprimé avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compte
      @compte = Compte.friendly.find(params[:id].present? ? params[:id] : params[:compte_id])
    end

    def calcul_solde_balance
      @total_factures  = @compte.factures.sum(:montant)
      @total_paiements = @compte.paiements.sum(:montant)
      @solde = @total_paiements - @total_factures
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def compte_params
      params.require(:compte).permit(:organisation_id, :nom, :civilité, :adresse1, :adresse2, :cp, :ville, :num_allocataire, :mémo,
                                      contacts_attributes: [:id, :nom, :fixe, :portable, :email, :mémo, :prevenir, :_destroy])
    end

    def sortable_columns
      %w{structures.nom comptes.nom comptes.civilité comptes.adresse1 comptes.cp comptes.ville comptes.num_allocataire comptes.enfants_count}
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

end
