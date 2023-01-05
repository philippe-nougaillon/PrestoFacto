class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[dashboard]

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

  def dashboard
    authorize :pages
    @organisation = current_user.organisation

    @results = current_user
              .organisation
              .factures
              .unscoped
              .where("factures.created_at BETWEEN ? AND ?", Date.today - 1.year, Date.today)
              .group("TO_CHAR(factures.created_at, 'YYYY-MM')")
              .sum(:montant)

    @results = @results.sort_by { |key| key }.to_h

  end
end
