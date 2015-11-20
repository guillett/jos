class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all

  def summary
    hash = {}

    sections_vigueur = sections
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
  
  def summary_start_id id
    hash = {}

    sections_vigueur = sections.select{|s| s.state == 'VIGUEUR'}
                           .sort_by { |s| s.order }
                           .each do |s|
      hash[s.id_section_origin] = [] if hash[s.id_section_origin].nil?
      hash[s.id_section_origin] << s
    end

    sections_vigueur.each do |s|
      next if s.id_section_parent_origin.nil? || hash[s.id_section_parent_origin].nil?
      hash[s.id_section_parent_origin].each { |p| p.sections << s }
    end

    sections_vigueur.select{ |s| s.id == id }
  end

  def self.with_displayable_sections_and_articles_by_escape_title escape_title
    with_displayable_sections_and_articles().find_by escape_title: escape_title
  end

  def self.with_displayable_sections_and_articles_by_code_id code_id
    with_displayable_sections_and_articles().find(code_id)
  end

  private

  def self.with_displayable_sections_and_articles
    Code.includes(sections: :articles).where(sections: { state: ['VIGUEUR','ABROGE_DIFF'] })
  end

end