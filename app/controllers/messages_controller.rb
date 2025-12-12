class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy traiter archiver ]
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :verify_authenticity_token
  before_action :is_user_authorized, except: %i[ index new create traiter archiver ]

  # GET /messages or /messages.json
  def index
    authorize Message

    if ['philippe.nougaillon@aikku.eu', 'pierre-emmanuel.dacquet@aikku.eu', 'sebastien.pourchaire@aikku.eu'].include?(current_user.email)
      @messages = Message.all
    else
      @messages = current_user.organisation.messages.ordered
    end

    unless params[:search].blank?
      s = "%#{params[:search].upcase}%"
      @messages = @messages.where('messages.email ILIKE :search OR messages.objet ILIKE :search OR messages.contenu ILIKE :search', {search: s})
    end

    unless params[:state].blank?
      @messages = @messages.where("messages.workflow_state = ?", params[:state].to_s.downcase)
    end

    @messages = @messages.page(params[:page])
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    authorize Message

    @message = Message.new
    @offre = params[:offre]
    if params[:facture_slug]
      @facture = Facture.find_by(slug: params[:facture_slug])
      @message.organisation_id = @facture.organisation.id
      @message.email = params[:email]
      @message.facture_slug = params[:facture_slug]
    end
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    authorize Message

    if verify_recaptcha || Rails.env.development?
      @message = Message.new(message_params)
      respond_to do |format|
        if @message.save
          if @message.organisation_id
            MessageMailer.with(message: @message).notification_organisation.deliver_now
          else
            MessageMailer.with(message: @message).notification_dev.deliver_now
          end

          format.html { redirect_to new_message_path, notice: "Votre message a bien été pris en compte." }
          format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:alert] = "Problème avec reCAPTCHA, merci de réessayer"
      render 'new'
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # WORKFLOW

  def traiter
    if @message.valid?
      if @message.can_traiter?
        @message.traiter!
        redirect_to @message, notice: "Message modifié. État passé à 'traité'."
      elsif @message.traité?
        redirect_to @message, alert: "Le message est déjà traité"
      else
        redirect_to @message, alert: "Le message ne peut pas être traité"
      end
    else
      redirect_to @message, alert: "Le message n'est pas valide. Il ne peut pas être traité"
    end
  end

  def archiver
    if @message.valid?
      if @message.can_archiver?
        @message.archiver!
        redirect_to @message, notice: "Message modifié. État passé à 'archivé'."
      elsif @message.archivé?
        redirect_to @message, alert: "Le message est déjà archivé"
      else
        redirect_to @message, alert: "Le message ne peut pas être archivé"
      end
    else
      redirect_to @message, alert: "Le message n'est pas valide. Il ne peut pas être archivé"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:email, :objet, :contenu, :organisation_id, :facture_slug)
    end

    def is_user_authorized
      authorize @message
    end
end
