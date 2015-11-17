module CodesHelper

  def display_summary(sections)

    content = "<ul>"
    sections.each do |s|

      if s.articles.where(state: "VIGUEUR").empty?
        content += "<li>" + s.title + "</li>"
      else
        content += "<li>" + link_to(s.title, section_path(s)) + "</li>"
      end
      if !s.sections.empty?
        content += display_summary(s.sections)
      end
    end
    content += "</ul>"

    content
  end

end
