class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all
  has_many :sections_with_valid_links, -> { includes(:section_links_valid, :section_article_links_valid) }, class_name: "Section"

  has_many :code_section_links
  has_many :valid_sections, -> { where(code_section_links: {state:  "VIGUEUR"}).order('"code_section_links"."order"') }, through: :code_section_links, source: :section


  def summary
    own_sections = sections_with_valid_links
    section_links = own_sections.map(&:section_links_valid).compact.flatten
    section_article_links = own_sections.map(&:section_article_links_valid).compact.flatten

    section_hash = preload_section_links(own_sections, section_links)
    preload_section_article_links(own_sections, section_article_links)

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

  def preload_section_article_links(sections, sections_article_links)
    sections_hash = sections.reduce({}) { |h, section| h[section.id]=section; h }

    sections_article_links.each do |sal|
      source = sections_hash[sal.section_id]
      if source.nil?
        puts "unknown section #{sal.section_id}"
        next
      end
      sal.section = source
      source.section_article_links_preloaded << sal
    end
  end

  def summary_start_id section_id
    sections = Section.all.to_ary
    section_links = SectionLink.all
    section_hash = preload_section_links sections, section_links

    section_hash[section_id]
  end

end