class Jtext < ActiveRecord::Base
  has_many :jorfcont_jtext_links
  has_many :jorfconts, through: :jorfcont_jtext_links
  has_and_belongs_to_many :keywords
end
