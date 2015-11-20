class VersionArticleMap
  include HappyMapper

  tag 'VERSION'
  attribute :id_article_origin, String, :tag => 'id'
end