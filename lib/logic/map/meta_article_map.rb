class MetaArticleMap
  include HappyMapper

  tag 'META_ARTICLE'

  has_one :state, String, :xpath => 'ETAT'
  has_one :start_date, DateTime, :xpath => 'DATE_DEBUT'
  has_one :end_date, DateTime, :xpath => 'DATE_FIN'
end