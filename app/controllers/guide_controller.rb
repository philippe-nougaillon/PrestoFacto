class GuideController < ApplicationController

  # on saute la sécurité 
  skip_before_action :authenticate_user!, only: [:a_propos, :guide]

  def a_propos
  end

  def guide
  end

end
