class CodeSectionLink < ActiveRecord::Base
  belongs_to :code
  belongs_to :section
end
