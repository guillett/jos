module SectionsHelper

  def display_article_summary(articles)

    content = "<ul>"
    articles.each do |a|
      content += "<li>" + a.id_article_origin + "</li>"
    end
    content += "</ul>"

    content
  end

end
