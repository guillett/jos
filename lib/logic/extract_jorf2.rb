require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JCONT_PATTERN = 'conteneur/**/*.xml'

  def initialize update=false
    @update = update
  end

  def extract_conteneur_xml_paths path
    Dir.glob(File.join(path, JCONT_PATTERN))
  end

  def extract_jorf2 path
    jorfcont_paths = extract_conteneur_xml_paths(path)
    Parallel.map(jorfcont_paths, in_processes: ENV['PARALLEL_PROCESSES'].try(:to_i), :progress => "Containers") do |jorfcont_path|
      extract_full_container(jorfcont_path, path)
    end
  end

  def extract_full_container(jorfcont_path, path)
    jorfcont_map = JorfcontMap.parse(File.read(jorfcont_path), :single => true)
    jorfcont = jorfcont_map.to_jorfcont

    # récupérer les texts, avec les struct et les versions, en partant 
    jorfcont_map.link_cont_text_maps.each do |link_cont_text_map|
      id_jorftext_origin = link_cont_text_map.id_jorftext_origin
      jstruct_map = find_jstruct_map_by_id_jorftext_origin(id_jorftext_origin, path)
      jversion_map = find_jversion_map_by_id_jorftext_origin(id_jorftext_origin, path)

      if jversion_map && !jstruct_map
        raise 'OUI'
      end

      if jstruct_map
        jtext = jstruct_map.to_jtext
        jtext.title_full = jversion_map.title_full
        jtext.permanent_link = jversion_map.permanent_link

        jorfcont.jtexts << jtext
        # TODO: ajouter les keywords

        # ajouter les liens de niveau 2
        jsections = jstruct_map.link_text_section_maps.map do |section_map|
          full_path = full_path_from_id_origin(section_map.id_jsection_origin)
          full_path = File.join(path, 'section_ta/JORF/SCTA', full_path) 
          if File.exists? full_path
            JsctaMap.parse(File.read(full_path))
          else
            $stderr.puts "Missing SCTA file: #{full_path}"
            nil
          end
        end.compact.to_jsection

        jtext.sections = jsections
      end
    end

    Jorfcont.import([jorfcont], validate: false)
    Jtext.import(jorfcont.jtexts.to_ary, validate: false)
    jorfcont.jorfcont_jtext_links.each{|link| link.jorfcont_id = jorfcont.id; link.jtext_id = link.jtext.id}
    JorfcontJtextLink.import(jorfcont.jorfcont_jtext_links.to_ary, validate: false)

    # import sections
    sections = jorfcont.jtexts.map(&:jsections).flatten.compact
    Jsection.import(sections, validate: false)
    links = jorfcont.jtexts.map(&:jtext_jsection_links).flatten.compact.map{|link| link.jtext_id = link.jtext.id; link.jsection_id = link.jsection.id; link}
    JtextJectionLink.import(links, validate: false)
  end

  def full_path_from_id_origin(id_origin)
    filename = id_origin + ".xml"
    dirname = dirname_from_id_origin(id_origin)
    File.join(dirname, filename)
  end

  def find_jstruct_map_by_id_jorftext_origin(id_jorftext_origin, path)
    find_x_map_by_id_origin(id_jorftext_origin, path, 'struct')
  end

  def find_jversion_map_by_id_jorftext_origin(id_jorftext_origin, path)
    find_x_map_by_id_origin(id_jorftext_origin, path, 'version')
  end

  def find_x_map_by_id_origin(id_origin, path, struct_or_version)
    clazz = "J#{struct_or_version}Map".constantize
    full_path = full_path_from_id_origin(id_origin)
    full_path = File.join(path, "texte/#{struct_or_version}/JORF/TEXT", full_path)
    if File.exists?(full_path)
      clazz.send(:parse, File.read(full_path), single: true)
    else
      $stderr.puts "missing #{struct_or_version} file: #{full_path}"
      nil
    end
  end

  def dirname_from_id_origin(id_origin)
    dirs = id_origin[8..id_origin.length-3]
    dirs[0,2] + "/" + dirs[2,2] + "/" + dirs[4,2] + "/" + dirs[6,2] + "/" + dirs[8,2]
  end

end
