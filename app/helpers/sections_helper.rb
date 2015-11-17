module SectionsHelper

  def display_section_summary(articles)

    content = "<ul>"
    articles.each do |a|
      content += "<li>" + a.id_article_origin + "</li>"
    end
    content += "</ul>"

    content
  end

end
