class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :set_layout_variables
  
  # Ensuring PUNDIT policies and scopes are used
  #after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if resource.role == 'user'
      moncompte_index_path
    else
      root_path
    end
  end

private
    def set_layout_variables
      @site_name = "PrestoFActo"
      version = "v5.1.a"
      @title = @site_name + ' ' + version

      @ctrl = params[:controller]
    end

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé.e à effectuer cette action !"
      redirect_to(request.referrer || (current_user.role == 'user' ? moncompte_index_path : root_path))
    end

end
