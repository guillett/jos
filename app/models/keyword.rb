class Keyword < ActiveRecord::Base
  has_many :jtext_keywords, dependent: :delete_all
  has_many :jtexts, through: :jtext_keywords
end
