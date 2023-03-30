class ComptesController < ApplicationController
  before_action :set_compte, only: [:show, :balance, :edit, :update, :destroy]
  before_action :calcul_solde_balance, only: [:show, :balance]

  helper_method :sort_column, :sort_direction

  # GET /comptes
  # GET /comptes.json
  def index
    authorize Compte

    @structures = current_user.organisation.structures

    if current_user.visiteur?
      @comptes = Compte.where(id: Contact.find_by(email: current_user.email).compte_id)
    else
      @comptes = current_user.organisation.comptes
    end
    
    unless params[:search].blank?
      s = "%#{params[:search].upcase}%"
      @comptes = @comptes.joins(:enfants).where('enfants.badge ILIKE :search OR enfants.prénom ILIKE :search OR comptes.nom ILIKE :search OR comptes.cp ILIKE :search OR comptes.ville ILIKE :search OR comptes.num_allocataire ILIKE :search', {search: s})
    end

    # Appliquer le tri
    @comptes = @comptes.reorder(Arel.sql("#{sort_column} #{sort_direction}"))
    
    respond_to do |format|
      format.html do 
        @comptes = @comptes.page(params[:page])
      end

      format.xls do
        book = ComptesToXls.new(@comptes).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Comptes.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end
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
    
    1.times { @compte.contacts.build }
  end

  # GET /comptes/1/edit
  def edit
    authorize Compte
    
    @structures = current_user.organisation.structures
  end

  # POST /comptes
  # POST /comptes.json
  def create
    authorize Compte
    
    @compte = Compte.new(compte_params)

    respond_to do |format|
      if @compte.save
        create_contacts
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
        create_contacts
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

    def create_contacts
      if params[:acces] == "1"
        @compte.contacts.each do |contact|
          if contact.prevenir && User.find_by(email: contact.email).nil?
            password = SecureRandom.hex(10)
            user = User.create(organisation: current_user.organisation, role: "visiteur", email: contact.email, password: password, confirmed_at: DateTime.now)
            UserMailer.with(user: user, password: password, organisation: current_user.organisation).welcome_with_password.deliver_now
            UserMailer.with(user: user).new_account_notification.deliver_now
          end
        end
      end
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
