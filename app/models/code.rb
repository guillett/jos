class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all

  def summary
    sections_vigueur = sections.where(state: 'VIGUEUR')
    level1 = sections_vigueur.select{ |s| s.level == 1 }.sort_by { |s| s.order }
    level1.each{|l1| fetch_children(l1, sections_vigueur)}
    level1
  end


  private
  def fetch_children(father, sections)
    children = sections.select{|s| s.level == (father.level + 1) && s.id_section_parent_origin == father.id_section_origin }.sort_by{|s| s.order}

    if !children.empty?
      children.each{|c| fetch_children(c, sections)}
    end

    father.sections = children
  end

end