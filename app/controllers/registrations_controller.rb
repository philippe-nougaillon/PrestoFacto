class RegistrationsController < Devise::RegistrationsController
    #prepend_before_action :check_captcha, only: [:create]

    def new
        super
        # logger.debug "SIGNUP"
    end

    def create
        if verify_recaptcha || Rails.env.development?
            @user = User.new(user_params)
            Organisation.create_from_signup(@user, params[:organisation], params[:structure], params[:zone])
            if @user.save
                sign_in @user
                redirect_to comptes_path, notice: "Bienvenue ! Votre compte créé avec succès."
                UserMailer.with(user: @user).welcome.deliver_now
                UserMailer.with(user: @user).new_account_notification().deliver_now
            else
                render :new, alert: @user.errors.full_messages
            end
        else 
            redirect_to new_user_registration_path(email: params[:user][:email], organisation: params[:organisation], structure: params[:structure], zone: params[:zone], password: params[:user][:password]), alert: "Problème avec reCAPTCHA"
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