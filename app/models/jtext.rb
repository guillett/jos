class Jtext < ActiveRecord::Base
  has_many :jtext_jarticle_links
  has_many :jarticles, through: :jtext_jarticle_links

  has_many :jtext_jsection_links
  has_many :jsections, through: :jtext_jsection_links

  has_many :jtext_keywords, dependent: :delete_all
  has_many :keywords, through: :jtext_keywords

end
