class Section < ActiveRecord::Base
  belongs_to :code
  has_many :articles, :dependent => :delete_all

  attr_accessor :sections

  after_initialize do
    @sections=[]
  end

end
