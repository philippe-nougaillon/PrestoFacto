class GuideController < ApplicationController

  # on saute la sécurité 
  skip_before_action :authenticate_user!, only: [:about, :utilisation]

  def about
  end

  def utilisation
  end

end
