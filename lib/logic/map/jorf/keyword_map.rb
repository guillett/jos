class KeywordMap
  include HappyMapper
  tag 'MC'
  content :label, String

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def to_keyword
    Keyword.new(to_hash)
  end

  def to_keyword_update
    keyword = Keyword.where(label: @label).first
    keyword.destroy if keyword
    Keyword.new(to_hash)
  end
end