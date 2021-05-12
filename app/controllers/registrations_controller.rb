class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create]

    def new
        super
        # logger.debug "SIGNUP"
    end

    def create
        @user = User.new(user_params)
        status = verify_recaptcha(model: @user)

        respond_to do |format|
            if status && @user.save
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

                # on ajoute l'utilisateur à l'organisation
                @user.update(role: 'admin')
                @organisation.users << @user

                # on se connecte avec l'utilisateur créé mais comme le compte n'a pas été confirmé, 
                # un message demandera de le faire en allant répondre au courriel envoyé...
                # sign_in @user
                format.html { redirect_to root_url, notice: "Veuillez vérifier vos emails." }
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

    def check_captcha
        return if !verify_recaptcha(action: 'signup')

        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides reCAPTCHA
        set_minimum_password_length

        respond_with_navigational(resource) do
            flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
            render :new
        end
    end
    
end