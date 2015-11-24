class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])

    @articles = @section.section_article_links.includes(:article).where(state: ['VIGUEUR', 'ABROGE_DIFF']).map(&:article)

    @sub_sections = @section.code.summary_start_id(@section.id).section_links_preloaded.map(&:target)
  end
end
  