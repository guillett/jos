class SectionLink < ActiveRecord::Base

  belongs_to :source,
             :class_name => 'Section', :foreign_key => 'source_id'
  belongs_to :target,
             :class_name => 'Section', :foreign_key => 'target_id'
end
