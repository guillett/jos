class SectionsController < ApplicationController
  def show
    @section = Section.joins(:articles).where(articles: {state: 'VIGUEUR'}).find(params[:id])
  end
end
