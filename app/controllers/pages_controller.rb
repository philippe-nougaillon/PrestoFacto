class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def welcome
  end

  def a_propos
  end

  def utilisation
  end

  def blog
  end
end
