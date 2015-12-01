class TextesController < ApplicationController
  def show
    @jtext= Jtext.find_by(id_jorftext_origin: params[:id])
    @jorfcont_jtext_link = JorfcontJtextLink.find_by_jtext_id(@jtext.id)
  end
end