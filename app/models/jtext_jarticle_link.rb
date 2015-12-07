class JtextJarticleLink < ActiveRecord::Base
  belongs_to :jtext
  belongs_to :jarticle, dependent: :destroy
end
