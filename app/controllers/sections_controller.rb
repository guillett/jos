class SectionsController < ApplicationController
  def show
    @section = Section.with_article_displayable(params[:id])

    code_sections = Code.with_displayable_sections_and_articles_by_code_id(@section.code.id)
    @sub_sections = code_sections.summary_start_id(@section.id).first.sections
  end
end
  