class KeywordsController < ApplicationController
  def show
    @keywords = Keyword.where(label: params[:label]).includes(:jtext)
    @keywords = @keywords.page params[:page]
  end
end
