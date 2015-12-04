class KeywordsController < ApplicationController
  def show
    @keywords = Keyword.where(label: params[:label]).includes(:jtext)
  end
end
