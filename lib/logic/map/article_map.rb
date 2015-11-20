require './lib/logic/map/version_article_map'
#require './lib/logic/map/link_article_map'

class ArticleMap
  include HappyMapper
  tag 'ARTICLE'

  has_one :id, String, :xpath => 'META/META_COMMUN/ID'
  has_one :nature, String, :xpath => 'META/META_COMMUN/NATURE'
  has_one :nota, String, :xpath => 'NOTA/CONTENU'
  has_one :text, String, :xpath => 'BLOC_TEXTUEL/CONTENU'
  has_many :versions, VersionArticleMap, :xpath => 'VERSIONS'
  #has_many :links, LinkArticleMap, :xpath => 'LIENS'

  def nota
    @nota.gsub(/\n/, "<br/>")
  end

  def text
    @text.gsub(/\n/, "<br/>")
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def self.parse_with_escape_br xml, options
    self.parse(xml.gsub( /<br\/?>/, "\n"), options)
  end

  def extract_linked_versions
    article_version = []
    unless @versions.nil?
      @versions.map do |v|
        article_version = Article.find(v.id_article_origin)
      end
    end
    article_version
  end
end

