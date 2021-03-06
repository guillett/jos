require './lib/logic/map/article_version_map'
require './lib/logic/map/history_link_map'

class ArticleMap
  include HappyMapper
  tag 'ARTICLE'

  has_one :id_article_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :nature, String, :xpath => 'META/META_COMMUN/NATURE'
  has_one :nota, String, :xpath => 'NOTA/CONTENU'
  has_one :text, String, :xpath => 'BLOC_TEXTUEL/CONTENU'
  has_many :versions, ArticleVersionMap, :xpath => 'VERSIONS'
  has_one :state, String, :xpath => 'META/META_SPEC/META_ARTICLE/ETAT'
  has_one :start_date, DateTime, :xpath => 'META/META_SPEC/META_ARTICLE/DATE_DEBUT'
  has_one :end_date, DateTime, :xpath => 'META/META_SPEC/META_ARTICLE/DATE_FIN'
  has_one :number, String, :xpath => 'META/META_SPEC/META_ARTICLE/NUM'
  has_many :history_links, HistoryLinkMap, :xpath => 'LIENS'

  #has_many :links, LinkArticleMap, :xpath => 'LIENS'

  def nota
    clean_new_lines(@nota)
  end

  def text
    clean_new_lines(@text)
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }

    # when writing to output replace \n with <br/>
    hash["nota"] = nota
    hash["text"] = text

    hash.delete("versions")
    hash.delete("history_links")
    hash
  end

  def self.parse_with_escape_br xml, options
    # when reading xml replace <br/> with \n
    self.parse(xml.gsub( /<br\/?>/, "\n"), options)
  end

  def to_article
    article = Article.new(to_hash)
    article.history_links = history_links.map(&:to_history_link)
    article
  end

  def to_article_versions_hash
    unless @versions.nil?
      @versions.map do |versionArticleMap|
        h = versionArticleMap.to_hash
        h['source_id_article_origin'] = @id_article_origin
        h
      end
    end
  end

  def clean_new_lines(text)
    text.gsub(/\n+/, "\n").gsub(/^\n/, "").gsub(/\n$/, "")
  end

end

