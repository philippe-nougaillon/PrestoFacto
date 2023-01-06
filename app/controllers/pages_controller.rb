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
    authorize :pages, :dashboard?
    @organisation = current_user.organisation

    @results = current_user
              .organisation
              .factures
              .unscoped
              .where("factures.date BETWEEN ? AND ?", Date.today - 1.year, Date.today.beginning_of_month)
              .group("TO_CHAR(factures.date, 'YYYY-MM')")
              .sum(:montant)

    unless @results.keys.count == 12
      for i in 1..12 do
        key = (Date.today - i.months).strftime("%Y-%m")
        unless @results.key?(key)
          @results.store(key, 0)
        end
      end
    end

    @results = @results.sort_by { |key| key }.to_h

  end
end