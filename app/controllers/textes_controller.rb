class TextesController < ApplicationController
  def show
    @jtext= Jtext.find(params[:id])
    @jorfcont_jtext_link = JorfcontJtextLink.find_by_jtext_id(@jtext.id)
  end
end