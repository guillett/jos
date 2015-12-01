class Jorfcont < ActiveRecord::Base
  has_many :jorfcont_jtext_links
  has_many :jtexts, through: :jorfcont_jtext_links
end