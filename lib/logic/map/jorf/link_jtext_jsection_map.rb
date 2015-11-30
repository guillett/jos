class LinkJtextJsectionMap
  include HappyMapper
  tag 'LIEN_SECTION_TA'

  attribute :id_jsection_origin, String, :tag => 'id'
  attribute :number, String, :tag => 'num'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

end