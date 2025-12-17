class VacancesController < ApplicationController
  before_action :set_vacance, only: %i[ show edit update destroy ]

  # GET /vacances or /vacances.json
  # def index
  #   @vacances = current_user.organisation.vacances
  # end

  # GET /vacances/1 or /vacances/1.json
  def show
  end

  # GET /vacances/new
  def new
    @vacance = Vacance.new
  end

  # GET /vacances/1/edit
  def edit
  end

  # POST /vacances or /vacances.json
  def create
    @vacance = Vacance.new(vacance_params)

    respond_to do |format|
      if @vacance.save
        format.html { redirect_to vacance_url(@vacance), notice: "Vacance was successfully created." }
        format.json { render :show, status: :created, location: @vacance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vacance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacances/1 or /vacances/1.json
  def update
    respond_to do |format|
      if @vacance.update(vacance_params)
        format.html { redirect_to vacance_url(@vacance), notice: "Vacance was successfully updated." }
        format.json { render :show, status: :ok, location: @vacance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vacance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacances/1 or /vacances/1.json
  def destroy
    @vacance.destroy

    respond_to do |format|
      format.html { redirect_to vacances_url, notice: "Vacance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacance
      @vacance = Vacance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vacance_params
      params.require(:vacance).permit(:zone, :nom, :début, :fin, :organisation_id)
    end
end
