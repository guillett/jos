module CodesHelper

  def display_summary(sections, id=nil)
    content = "<ul id='#{id}' class='nav'>"
    sections.each do |s|
      if s.section_article_links_preloaded.empty?
        content += "<li><a href='#'>" + s.title + "</a>"
      else
        content += "<li>" + link_to(s.title, section_path(s))
      end
      if !s.section_links_preloaded.empty?
        child_sections = s.section_links_preloaded
          .sort_by{ |sl| sl.order }
          .map{ |sl| sl.target }

        content += display_summary(child_sections)
      end
      content += "</li>"
    end
    content += "</ul>"

    content
  end

end