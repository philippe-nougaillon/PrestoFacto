class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :set_layout_variables
  
  # Ensuring PUNDIT policies and scopes are used
  #after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if resource.visiteur?
      moncompte_index_path
    else
      root_path
    end
  end

private
    def set_layout_variables
      @site_name = "PrestoFacto"
      version = "v5.4.a"
      @site_name_and_version = @site_name + ' ' + version

      @ctrl = params[:controller]
      @action = params[:action]
    end

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé(e) à effectuer cette action !"
      redirect_to(request.referrer || (current_user.visiteur? ? moncompte_index_path : root_path))
    end

end
