require './lib/logic/meta_article_map'
require './lib/logic/link_article_map'

class ArticleMap
  include HappyMapper
  tag 'ARTICLE'

  has_one :ID, String, :xpath => 'META/META_COMMUN/ID'
  has_one :meta_article, MetaArticleMap, :xpath => 'META/META_SPEC'
  has_one :nota, String, :xpath => 'NOTA/CONTENU'
  has_one :bloc_textuel, String, :xpath => 'BLOC_TEXTUEL/CONTENU'
  has_many :links, LinkArticleMap, :xpath => 'LIENS'
end