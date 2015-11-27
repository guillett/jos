class Jorfcont < ActiveRecord::Base
  has_many :jorftexts, through: :jorfconts_jorftexts
end
