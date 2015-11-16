class SectionArticleMap
  include HappyMapper

  tag 'LIEN_ART'
  attribute :state, String, :tag => 'etat'
  attribute :start_date, DateTime, :tag => 'debut'
  attribute :end_date, DateTime, :tag => 'fin'
  attribute :id_article_origin, String, :tag => 'id'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end