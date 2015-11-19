class Section < ActiveRecord::Base
  belongs_to :code
  has_and_belongs_to_many :articles

  attr_accessor :sections

  after_initialize do
    @sections=[]
  end

end
