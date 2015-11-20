class CodesController < ApplicationController

  def show
    @code = Code.with_displayable_sections_and_articles_by_escape_title params[:id]
  end
end
