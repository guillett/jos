module CodesHelper

  def display_summary(sections)

    content = "<ul>"
    sections.each do |s|
      content += "<li>" + s.title + "</li>"
      if !s.sections.empty?
        content += display_summary(s.sections)
      end
    end

    content += "</ul>"
    content
  end

end
