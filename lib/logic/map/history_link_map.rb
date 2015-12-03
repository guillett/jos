require './lib/logic/map/article_version_map'

class HistoryLinkMap
  include HappyMapper
  tag 'LIEN'

  attribute :id_text_origin, String, :tag => 'cidtexte'
  attribute :nature, String, :tag => 'naturetexte'
  attribute :order, Integer, :tag => 'num'
  attribute :text_number, String, :tag => 'numtexte'
  attribute :text_type, String, :tag => 'typelien'
  content :title, String

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def to_history_link
    HistoryLink.new(to_hash)
  end

end

