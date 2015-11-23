class SectionArticleLink < ActiveRecord::Base
  belongs_to :section
  belongs_to :article
end
