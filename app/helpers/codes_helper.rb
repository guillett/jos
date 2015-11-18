module CodesHelper

  def display_summary(sections, id=nil)
    content = "<ul id='#{id}' class='nav'>"
    sections.each do |s|
      if s.articles.to_ary.all? {|a| a.state != 'VIGUEUR'}
        content += "<li><a href='#'>" + s.title + "</a>"
      else
        content += "<li>" + link_to(s.title, section_path(s))
      end
      if !s.sections.empty?
        content += display_summary(s.sections)
      end
      content += "</li>"
    end
    content += "</ul>"

    content
  end

end
