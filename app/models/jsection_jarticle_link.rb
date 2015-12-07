class JsectionJarticleLink < ActiveRecord::Base
  belongs_to :jsection
  belongs_to :jarticle, dependent: :destroy
end
