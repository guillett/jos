require './lib/logic/map/jorf/link_cont_text_map'

class JorfcontMap
  include HappyMapper
  tag 'JO'

  has_one :id_jorfcont_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :nature, String, :xpath => 'META/META_COMMUN/NATURE'
  has_one :title, String, :xpath => 'META/META_SPEC/META_CONTENEUR/TITRE'
  has_one :number, String, :xpath => 'META/META_SPEC/META_CONTENEUR/NUM'
  has_one :publication_date, DateTime, :xpath => 'META/META_SPEC/META_CONTENEUR/DATE_PUBLI'

  has_many :link_cont_text_maps, LinkContTextMap, :tag => 'LIEN_TXT'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash.delete("link_cont_text_maps")
    hash
  end

  def to_jorfcont
    Jorfcont.new(to_hash)
  end

  def to_jorfcont_jorftext_link_hashes
    link_cont_text_maps.map { |lct| { id_jorfcont_origin: id_jorfcont_origin, id_jorftext_origin: lct.id_jorftext_origin, title: lct.title }}
  end

end