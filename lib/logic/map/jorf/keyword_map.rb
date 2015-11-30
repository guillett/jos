class KeywordMap
  include HappyMapper
  tag 'MC'
  content :label, String

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

end