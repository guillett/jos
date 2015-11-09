class HomeController < ApplicationController

	def index
		@titres = File.open('./codes_titles.txt').readlines
	end

end
