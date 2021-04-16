class RegistrationsController < Devise::RegistrationsController

    def new
        super
        # logger.debug "SIGNUP"
    end

    def create
        # On crée l'organisation 
        organisation = Organisation.create( nom: params[:organisation], 
                                            email: user_params[:email], 
                                            zone: 'A')

        organisation.structures.create(nom: params[:structure])

        # et quelques données de base pour aider la prise en main 
        organisation.structures.first.classrooms.create(nom: 'UNE CLASSE')
        organisation.comptes.create(nom: 'FAMILLE-TEST')
        organisation.facture_chronos.create(index: 1)
        organisation.tarif_types.create(nom: 'Général')
        organisation.prestation_types.create(nom: 'Repas')
        organisation.tarif_types
                    .first
                    .tarifs
                    .create(prestation_type: organisation.prestation_types.first, 
                            prix: 1.00)

        # Le premier utilisateur de l'organisation                        
        @user = organisation.users.new(user_params)
        @user.role = "admin"

        respond_to do |format|
            if @user.save
                # on se connecte avec l'utilisateur créé mais comme le compte n'a pas été confirmé, 
                # un message demandera de le faire en allant répondre au courriel envoyé...
                sign_in @user
            else
                format.html { render :new }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        super
    end

private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :admin, :organisation_id, :password, :password_confirmation)
    end
end