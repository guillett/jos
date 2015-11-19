class CodesController < ApplicationController

  def show
    @code = Code.with_displayable_sections_and_articles params[:id]
  end
end
