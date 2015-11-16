class Section < ActiveRecord::Base
  belongs_to :code

  attr_accessor :sections

  after_initialize do
    @sections=[]
  end

end
