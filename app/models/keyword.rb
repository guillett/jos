class Keyword < ActiveRecord::Base
  has_many :jtext_keywords
  has_many :jtexts, through: :jtext_keywords
end
