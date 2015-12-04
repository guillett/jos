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

    @history_link_modif = HistoryLink.where(article_id: @article_1.id, text_type: "MODIFICATION").first
    @jarticle_modif_id = JtextJarticleLink.includes(:jtext).where(jtexts: { id_jorftext_origin: @history_link_modif.id_text_origin }, jtext_jarticle_links: { order: @history_link_modif.order }).first.jarticle_id
    @jarticle_modif = Jarticle.find(@jarticle_modif_id)
  end

  private

  def diff_to_array(article_1, article_2)
    Diffy::Diff.new(article_1, article_2, :allow_empty_diff => false).each_chunk.to_a
  end

end