class FactureMessagesController < ApplicationController
  before_action :set_facture_message, only: %i[ show edit update destroy ]
  before_action :is_user_authorized, except: %i[ index new create ]


  # GET /facture_messages or /facture_messages.json
  def index
    authorize FactureMessage
    @facture_messages = current_user.organisation.facture_messages
  end

  # GET /facture_messages/1 or /facture_messages/1.json
  def show
  end

  # GET /facture_messages/new
  def new
    authorize FactureMessage

    @facture_message = FactureMessage.new
    @facture_message.organisation = current_user.organisation
  end

  # GET /facture_messages/1/edit
  def edit
  end

  # POST /facture_messages or /facture_messages.json
  def create
    authorize FactureMessage

    @facture_message = FactureMessage.new(facture_message_params)

    respond_to do |format|
      if @facture_message.save
        format.html { redirect_to facture_messages_path, notice: "Message créé avec succès." }
        format.json { render :show, status: :created, location: @facture_message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @facture_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facture_messages/1 or /facture_messages/1.json
  def update
    respond_to do |format|
      if @facture_message.update(facture_message_params)
        format.html { redirect_to facture_messages_path, notice: "Message modifié avec succès." }
        format.json { render :show, status: :ok, location: @facture_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @facture_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facture_messages/1 or /facture_messages/1.json
  def destroy
    @facture_message.destroy
    respond_to do |format|
      format.html { redirect_to facture_messages_url, notice: "Message supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facture_message
      @facture_message = FactureMessage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def facture_message_params
      params.require(:facture_message).permit(:contenu, :actif, :organisation_id)
    end

    def is_user_authorized
      authorize @facture_message
    end
end
