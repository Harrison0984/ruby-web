class GridgameController < ApplicationController
	layout "manage"
	
	def index
		@admin = User.find(session[:userid])
		@grids = Grid.all
	end
end
