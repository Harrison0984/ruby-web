require 'rufus-scheduler'

class MainController < ApplicationController
	def index
		if session.has_key?(:userid) == false || session[:userid] == 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		else
			@gridconfigs = Gridconfig.all
			@user = User.find(session[:userid])
			@grids = Grid.last(4)

			griddata = Grid.last
			if griddata != nil
				@nextbar = griddata.id+1
			end

			tasklog = Tasklog.last
			if tasklog != nil
				@seconds = (tasklog.nexttime - Time.new - 8 * 3600).to_i

				#fix service is stoped,then nexttime < Time.new
				if @seconds < 0
					seconds = 300
				end
			end

			@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
		end
	end

	def show
	end
end
