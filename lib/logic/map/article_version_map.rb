class ArticleVersionMap
  include HappyMapper

  tag 'VERSION/LIEN_ART'
  attribute :id_article_origin, String, :tag => 'id'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end