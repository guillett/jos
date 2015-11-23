class SectionMap
  include HappyMapper

  tag 'LIEN_SECTION_TA'
  content :title, String
  attribute :level, Integer, :tag => 'niv'
  attribute :state, String, :tag => 'etat'
  attribute :start_date, DateTime, :tag => 'debut'
  attribute :end_date, DateTime, :tag => 'fin'
  attribute :target_id_section_origin, String, :tag => 'id'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end