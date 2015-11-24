module ArticlesHelper
  def format_article_text(text)
    "<p>" + text.gsub(/\n/, "</p><p>") + "</p>"
  end
end