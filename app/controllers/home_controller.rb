class HomeController < ApplicationController

	def index
    @codes = Code.order(:title)
  end

end
