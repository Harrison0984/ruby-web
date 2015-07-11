require 'rufus-scheduler'

class MainController < ApplicationController
	def index
		

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
		end

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
		#fix service is stoped,then nexttime < Time.new
		if @seconds < 0
			@seconds = 300
		end
	end
end
