class Jtext < ActiveRecord::Base
  has_many :jorfcont_jtext_links
  has_many :jorfconts, through: :jorfcont_jtext_links

  has_many :jtext_jarticle_links
  has_many :jarticles, through: :jtext_jarticle_links

  has_many :jtext_jsection_links
  has_many :jsections, through: :jtext_jsection_links

  has_and_belongs_to_many :keywords
end
