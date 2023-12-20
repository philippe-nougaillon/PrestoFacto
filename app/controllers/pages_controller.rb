class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def accueil
    redirect_to comptes_path if user_signed_in?
  end

  def utilisation
  end

  def actualites
  end

  def confidentialite
  end

  def conditions_generales_de_vente
  end

  def guide
    authorize :pages
  end
end