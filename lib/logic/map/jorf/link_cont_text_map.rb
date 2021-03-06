class LinkContTextMap
  include HappyMapper
  tag 'LIEN_TXT'

  attribute :id_jorftext_origin, String, :tag => 'idtxt'
  attribute :title, String, :tag => 'titretxt'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

end