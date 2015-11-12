class Code < ActiveRecord::Base
  has_many :sections, :dependent => :delete_all

  def summary
    level1 = sections.where(level: 1, state: 'VIGUEUR').order(:order)

    sections.where(level: 2, state: 'VIGUEUR').order(:order).each do |level2|
      s = level1.find{|s| s.id_section_origin = level2.id_section_parent_origin }
      s.sections = [] if s.sections.nil?
      s.sections.push(level2)
    end

    level1
  end

end