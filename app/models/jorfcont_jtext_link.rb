class JorfcontJtextLink < ActiveRecord::Base
  belongs_to :jorfcont
  belongs_to :jtext, dependent: :destroy
end
