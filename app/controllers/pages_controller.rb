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

  def dashboard
    @months = []
    @organisation = current_user.organisation

    @results = current_user
              .organisation
              .factures
              .unscoped
              .where("factures.created_at BETWEEN ? AND ?", Date.today - 1.year, Date.today)
              .group("DATE_PART('month', factures.created_at)")
              .sum(:montant)

    @results.keys.each do |key|
      @months << t("date.month_names")[key].humanize
    end

  end
end
