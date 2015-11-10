require 'nokogiri'

class Extractor

  def load_xml path
    f = File.open(path)
    xml = Nokogiri.Slop(f.read)
    f.close()
    xml
  end

  def load_version_xmls path
    Dir.glob(path + '/**/version/*.xml').map do |version_file|
      load_xml version_file
    end
  end

  def load_structure_xmls path
    Dir.glob(path + '/**/struct/*.xml').map do |struct_file|
      load_xml struct_file
    end
  end

  def get_code_title xml
    xml.TEXTE_VERSION.META.META_SPEC.META_TEXTE_VERSION.TITRE.content
  end

  def get_code_titles path
    version_xmls = load_version_xmls(path)
    code_titles = version_xmls.map { |version_xml| get_code_title (version_xml)}
    code_titles.uniq.sort
  end

  def extract_codes path
    get_code_titles(path).map {|title| Code.create!(title: title)}
  end

  def get_section_links xml
    xml.TEXTELR.STRUCT.LIEN_SECTION_TA
  end

  def get_section_links_content list
    unless list.is_a?(Array)
      list = [list]
    end

    list.map{ |section| section.content }
  end

  def extract_section_links_one_struct_xml xml
    links = get_section_links( xml )

    unless links.is_a?(Array)
      links = [links]
    end

    links.map.with_index {|link, index| Section.create!(  id_section_origin: link["id"],
                                        title: link.content,
                                        level: link["niv"],
                                        state: link["etat"],
                                        start_date: link["debut"],
                                        end_date: link["fin"],
                                        order: index,
                                        id_section_parent_origin: "")}
   end
end
