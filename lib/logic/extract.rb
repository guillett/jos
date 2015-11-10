require 'nokogiri'

def load_xml path
  Nokogiri.Slop(File.open(path).read)
end

def load_version_xmls path
  Dir.glob(path + '/**/version/*.xml').map do |version_file|
    f = File.open(version_file)
    xml = Nokogiri.Slop(f.read)
    f.close()
    xml
  end
end

def get_code_title xml
  xml.TEXTE_VERSION.META.META_SPEC.META_TEXTE_VERSION.TITRE.content
end

def get_code_titles path
  version_xmls = load_version_xmls(path)
  code_titles = version_xmls.map { |version_xml| get_code_title (version_xml)}
  code_titles.uniq!.sort!
end
