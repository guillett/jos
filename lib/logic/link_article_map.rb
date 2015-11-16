class LinkArticleMap
  include HappyMapper

  tag 'LIEN'

  content :title, String
  attribute :id_link_origin, String, :tag => 'id'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end