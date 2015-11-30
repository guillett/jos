class Jsection < ActiveRecord::Base
  has_many :jsection_jarticle_links
  has_many :jarticles, through: :jsection_jarticle_links
end
