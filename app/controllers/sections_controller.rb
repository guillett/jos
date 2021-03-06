class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])

    @articles = @section.section_article_links_valid.includes(:article).map(&:article)

    @sub_sections = @section.code.summary(@section.id).section_links_preloaded.map(&:target)
  end
end
  