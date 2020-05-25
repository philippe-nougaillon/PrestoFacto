class GuideController < ApplicationController

  # on saute la sécurité 
  skip_before_action :authenticate_user!, only: [:a_propos, :utilisation]

  def a_propos
  end

  def utilisation
  end

end
