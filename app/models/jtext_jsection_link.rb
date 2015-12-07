class JtextJsectionLink < ActiveRecord::Base
  belongs_to :jtext
  belongs_to :jsection, dependent: :destroy
end
