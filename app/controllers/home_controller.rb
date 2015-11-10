class HomeController < ApplicationController

	def index
    @codes = Code.all
  end

end
