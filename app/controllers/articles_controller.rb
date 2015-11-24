class ArticlesController < ApplicationController

  def show
    @article = Article.find_by(id_article_origin: params[:id])
  end

  def diff
    @article_1 = Article.find_by(id_article_origin: params[:article_1_id])
    @article_2 = Article.find_by(id_article_origin: params[:article_2_id])
    @diff = display_diff(@article_1.text, @article_2.text)
  end

  private

  def display_diff(article_1, article_2)
    article_1 = article_1.gsub( /<br\/?>/, "\n")
    article_2 = article_2.gsub( /<br\/?>/, "\n")
    Diffy::Diff.new(article_1, article_2).to_s(:html_simple)
  end

end