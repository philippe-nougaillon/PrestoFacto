class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  before_action :authenticate_user!
  before_action :set_layout_variables
  before_action :prepare_exception_notifier
  
  # Ensuring PUNDIT policies and scopes are used
  # after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(user)
    if user.visiteur?
      moncompte_index_path
    else
      comptes_path
    end
  end

private
    def set_layout_variables
      @ctrl = params[:controller]
      @action = params[:action]
      @site_name = "PrestoFacto"
      set_meta_tags(
        description: "Facturation de vos services journaliers. PrestoFacto aide les petites organisations dans la gestion et la facturation de leurs prestations (repas, garderie, activités périscolaires, nuitée d'hébergement, colonie de vacances, etc...)",
        keywords: "Facturation, facture, prestation, repas, cantine, garderie, périscolaire, nuitée, colonie, colonie de vacances",
        author: ['Philippe NOUGAILLON', 'Pierre-Emmanuel DACQUET', 'Studio Philnoug&Partners']
      )
    end

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé(e) à effectuer cette action !"
      redirect_to(request.referrer || (current_user.visiteur? ? moncompte_index_path : root_path))
    end

    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
        current_user: current_user
      }
    end

end
