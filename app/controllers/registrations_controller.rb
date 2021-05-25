class RegistrationsController < Devise::RegistrationsController
    #prepend_before_action :check_captcha, only: [:create]

    def new
        super
        # logger.debug "SIGNUP"
    end

    def create
        @user = User.new(user_params)
        if params[:question] == ENV['REPONSE_SECRETE']
            Organisation.create_from_signup(@user, params[:organisation], params[:structure])
        else
            flash[:alert] == 'Mauvaise réponse !'
        end
        
        respond_to do |format|
            if @user.save
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