class CodesController < ApplicationController

  def show
    @code = Code.with_vigueur_sections_and_articles params[:id]
  end
end
