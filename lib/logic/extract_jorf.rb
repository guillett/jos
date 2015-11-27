require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JORFTEXT_STRUCTURE_PATTERN = 'texte/struct/**/*.xml'

  def extract_struct_xml_paths path
    Dir.glob(File.join(path, JORFTEXT_STRUCTURE_PATTERN))
  end

  def extract_jorf path
    jorftext_struct_paths = extract_struct_xml_paths(path)
    puts "we have #{jorftext_struct_paths.length} jorf text"
    jorftext_struct_paths.map do |jorftext_struct_path|
      JorftextMap.parse(File.read(jorftext_struct_path), :single => true).to_jorftext
    end
  end

end
