class GridgameController < ApplicationController
	layout "manage"
	
	def index
		@grids = Grid.all
	end
end
