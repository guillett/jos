class ArticlesController < ApplicationController

  def show
    @article = Article.where(state: 'VIGUEUR' ).find_by(id_article_origin: params[:id])
  end

end
