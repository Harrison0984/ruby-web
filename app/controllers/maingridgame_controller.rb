class MaingridgameController < ApplicationController
	layout "main"

	def index
		if session.has_key?(:userid) == false || session[:userid] == 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		else
			@grids = Grid.last(60)
			@user = User.find(session[:userid])
		end
	end
end
