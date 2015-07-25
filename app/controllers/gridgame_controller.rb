class GridgameController < ApplicationController
	layout "manage"
	
	def index
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			@grids = Grid.last(270)
		end
	end

	def isadmin (userid)
		if session.has_key?(:userid) == false || session[:userid] == 0
			return 0
		else
			@user = User.find(session[:userid])
			if @user == nil
				return 0
			else
				return @user.level
			end
		end
	end
end
