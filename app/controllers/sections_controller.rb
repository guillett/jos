class SectionsController < ApplicationController
  def show
    @section = Section.joins(:articles).where(articles: {state: ['VIGUEUR', 'ABROGE_DIFF']}).find(params[:id])
  end
end
