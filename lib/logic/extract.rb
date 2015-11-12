require 'nokogiri'

class Extractor

  VERSION_PATTERN = 'version/*.xml'
  STRUCTURE_PATTERN = 'struct/*.xml'
  TEXTE_PATTERN = '/**/texte/'

  def extract_text_folder_paths path
    Dir.glob(path + TEXTE_PATTERN)
  end

  def extract_struct_xml_path path
    Dir.glob(path + STRUCTURE_PATTERN).first
  end

  def extract_version_xml_path path
    Dir.glob(path + VERSION_PATTERN).first
  end

  def get_code_title xml
    xml.TEXTE_VERSION.META.META_SPEC.META_TEXTE_VERSION.TITRE.content
  end

  def extract_codes_and_sections2 path
    texte_folders = extract_text_folder_paths(path)
    puts "#{texte_folders.length} text folders detected"

    codes = texte_folders.map do |folder|
      puts "processing #{folder}"

      version_path = extract_version_xml_path(folder)
      structure_path = extract_struct_xml_path(folder)

      if folder_invalid?(structure_path, version_path)
        $stderr.puts "invalid texte folder: #{folder}"
        next
      end

      code = Code.new(title: get_code_title( Nokogiri.Slop(File.read(version_path))))
      structMap = StructMap.parse(File.read(structure_path), :single => true)
      structMap.sections.each {|s| code.sections.push(Section.new(s.to_hash)) }

      puts "#{code.title} is built"
      code
    end

    codes.select{|c| !c.nil? }
  end

  def folder_invalid?(structure_path, version_path)
    version_path.nil? || structure_path.nil?
  end

end
