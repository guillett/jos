class Section < ActiveRecord::Base
  belongs_to :code

  attr_accessor :sections

end
