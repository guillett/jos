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

    @jarticle_modif = get_article_modificator
  end

  private

  def diff_to_array(article_1, article_2)
    Diffy::Diff.new(article_1, article_2, :allow_empty_diff => false).each_chunk.to_a
  end

  def get_article_modificator
    @history_link_modif = HistoryLink.where(article_id: @article_2.id, text_type: ["MODIFICATION", "MODIFIE"]).first
    return nil if @history_link_modif.nil?

    jarticle_modif = JtextJarticleLink.includes(:jtext).where(jtexts: { id_jorftext_origin: @history_link_modif.id_text_origin }, jtext_jarticle_links: { order: @history_link_modif.order }).first
    return nil if jarticle_modif.nil?

    Jarticle.find(jarticle_modif.jarticle_id)
  end
end