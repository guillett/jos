class Jsection < ActiveRecord::Base
  has_many :jsection_jarticle_links
  has_many :jarticles, through: :jsection_jarticle_links

  has_many :jtext_jsection_links
  has_many :jtexts, through: :jtext_jsection_links
end
