class ArticlesController < ApplicationController

  def show
    @article = Article.find_by(id_article_origin: params[:id])
  end

  def diff
    @article_1 = Article.find_by(id_article_origin: params[:article_1_id])
    @article_2 = Article.find_by(id_article_origin: params[:article_2_id])

    article_1_text = ""
    @article_1.text.each_line {|line|  article_1_text += line.strip + "\n"}

    article_2_text = ""
    @article_2.text.each_line {|line|  article_2_text += line.strip + "\n"}

    @diff_array = diff_to_array(article_1_text.strip.chomp, article_2_text.strip.chomp).map { |line| line.gsub(/\n/, "<br/>").gsub(/<br\/>-/, "<br/>").gsub(/<br\/>\+/, "<br/>") }
  end

  private

  def diff_to_array(article_1, article_2)
    Diffy::Diff.new(article_1, article_2, :allow_empty_diff => false).each_chunk.to_a
  end

end