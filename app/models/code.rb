class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all

  def summary
    hash = {}

    sections_vigueur = sections.where(state: 'VIGUEUR')
      .sort_by { |s| s.order }
      .each do |s|
      hash[s.id_section_origin] = [] if hash[s.id_section_origin].nil?
      hash[s.id_section_origin] << s
    end

    sections_vigueur.each do |s|
      next if s.id_section_parent_origin.nil? || hash[s.id_section_parent_origin].nil?
      hash[s.id_section_parent_origin].each { |p| p.sections << s }
    end

    sections_vigueur.select{ |s| s.level == 1 }
  end

end