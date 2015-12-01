class KeywordsController < ApplicationController
  def show
    @keyword = Keyword.find_by_label(params[:label])
  end
end
