class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def accueil
  end

  def a_propos
  end

  def utilisation
  end

  def blog
  end

  def confidentialite
  end

  def conditions_generales_de_vente
  end
end
