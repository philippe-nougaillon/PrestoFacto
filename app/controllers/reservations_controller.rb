class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :set_prestation_types, only: [:new, :edit]
  helper_method :sort_column, :sort_direction

  # GET /reservations
  # GET /reservations.json
  def index
    authorize Reservation

    params[:date] ||= Date.today
    
    organisation = current_user.organisation
    @reservations = organisation.reservations.actives
    @structures = organisation.structures
    @classrooms = organisation.classrooms
    @prestation_types = organisation.prestation_types
    
    unless params[:date].blank? || params[:date] == 'full'
      # la date demandée est hors période scolaire ?
      hps = Vacance.where("DATE(?) BETWEEN début AND fin", params[:date]).any?
      @reservations = @reservations.where(hors_période_scolaire: hps).where("DATE(?) BETWEEN début AND fin", params[:date])
    end

    unless params[:structure_id].blank?
      @reservations = @reservations.joins(enfant: [:compte]).where(comptes: { structure_id: params[:structure_id] })
      @classrooms = @classrooms.where(structure_id: params[:structure_id]) 
    end

    unless params[:classroom_id].blank?
      @reservations = @reservations.joins(:enfant).where(enfants: { classroom_id: params[:classroom_id] })      
    end

    unless params[:prestation_type_id].blank?
      @reservations = @reservations.where(prestation_type_id: params[:prestation_type_id]) 
    end

    unless params[:nom].blank?
      @reservations = @reservations.joins(:enfant).where("enfants.nom ILIKE ? OR enfants.prénom ILIKE ?", "%#{params[:nom]}%", "%#{params[:nom]}%")       
    end

    unless params[:state].blank?
      @reservations = @reservations.where("reservations.workflow_state = ?", params[:state].to_s.downcase)
    end

    # Appliquer le tri
    @reservations = @reservations.joins(:enfant => :classroom).reorder(Arel.sql("#{sort_column} #{sort_direction}"))

    @total_alg = 0
    @total_sp = 0

    @reservations = @reservations.page(params[:page])
  end

  def action
    return unless params[:reservations_id]
    réservations = Reservation.where(id: params[:reservations_id].keys)
    réservations_count = réservations.count

    case params[:action_name]
    when "Supprimer"
      réservations.each do | r | 
        r.destroy
      end
      flash[:notice] = "#{réservations_count} réservation.s supprimée.s" 
      redirect_to reservations_url
    end
  end

  def create_visiteur
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      redirect_to moncompte_index_path, notice: 'Réservation créée avec succès.'
    else
      redirect_to moncompte_index_path, alert: 'Réservation PB.'
    end

  end  

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    authorize @reservation

    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation supprimée avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_prestation_types
      @prestation_types = current_user.organisation.prestation_types
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:enfant_id, :prestation_type_id, :active, :début, :fin, :lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche, :matin, :midi, :soir, :hors_période_scolaire, :workflow_state)
    end

    def sortable_columns
      %w{structures.nom classrooms.nom enfants.nom enfants.menu_sp enfants.menu_all 
          reservations.début reservations.fin
          reservations.prestation_type_id
          reservations.lundi reservations.mardi reservations.mercredi reservations.jeudi reservations.vendredi reservations.samedi reservations.dimanche
          reservations.matin reservations.midi reservations.soir reservations.hors_période_scolaire
          reservations.workflow_state
        }
    end
  
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'reservations.id'
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

end
