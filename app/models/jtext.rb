class Jtext < ActiveRecord::Base
  has_many :jorfcont_jtext_links
  has_many :jorfconts, through: :jorfcont_jtext_links

  has_many :jarticles, dependent: :destroy

  has_many :keywords, dependent: :delete_all
end
