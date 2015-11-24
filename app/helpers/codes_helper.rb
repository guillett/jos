module CodesHelper

  def display_summary(sections, id=nil)
    content = "<ul id='#{id}' class='nav'>"
    sections.each do |s|
      if s.section_article_links.where(state: ['VIGUEUR', 'ABROGE_DIFF']).count == 0
        content += "<li><a href='#'>" + s.title + "</a>"
      else
        content += "<li>" + link_to(s.title, section_path(s))
      end
      if s.section_links_preloaded.size != 0
        child_sections = s.section_links_preloaded
          .select{|sl| %w{VIGUEUR ABROGE_DIFF}.include?(sl.state) }
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
