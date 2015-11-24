class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all
  has_many :code_section_links
  has_many :valid_sections, -> { where(code_section_links: {state:  "VIGUEUR"}).order('"code_section_links"."order"') }, through: :code_section_links, source: :section

  def summary
    sections = Section.all.to_ary
    section_links = SectionLink.all
    section_hash = preload_section_links sections, section_links

    valid_sections.map{|s| section_hash[s.id]}
  end

  def preload_section_links(sections, links)
    sections_hash = sections.reduce({}) { |h, section| h[section.id]=section; h }

    links.each do |link|
      source = sections_hash[link.source_id]
      target = sections_hash[link.target_id]
      link.source = source
      link.target = target
      source.section_links_preloaded << link
    end
    sections_hash
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