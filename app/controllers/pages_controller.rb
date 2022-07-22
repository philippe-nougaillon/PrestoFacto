class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def accueil
    redirect_to comptes_path if user_signed_in?
  end

  def a_propos
  end

  def utilisation
  end

  def actualite
  end

  def confidentialite
  end

  def conditions_generales_de_vente
  end
end
