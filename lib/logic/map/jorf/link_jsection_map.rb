class LinkJsectionMap
  include HappyMapper
  tag 'LIEN_SECTION_TA'

  attribute :id_jsection_origin, String, :tag => 'id'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

end