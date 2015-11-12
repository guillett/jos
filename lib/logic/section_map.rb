class SectionMap
  include HappyMapper

  tag 'LIEN_SECTION_TA'
  content :title, String
  attribute :niv, Integer
  attribute :etat, String
  attribute :debut, DateTime
  attribute :fin, DateTime
  attribute :id, String

  def to_hash
    attributes = { "title" => "title", "niv" => "level", "etat" => "state", "debut" => "start_date", "fin" => "end_date", "id" => "id_section_origin" }
    hash = {}
    instance_variables.each { |var| hash[attributes[var.to_s.delete("@")]] = instance_variable_get(var) }
    hash
  end
end