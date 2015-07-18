class GridgameController < ApplicationController
	layout "manage"
	
	def index
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			@grids = Grid.all
		end
	end
end
