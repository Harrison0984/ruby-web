require 'rufus-scheduler'

class MainController < ApplicationController
	def index

		curtime = Time.new
		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		if tasklog
			@seconds = tasklog.nexttime - curtime - 8 * 3600
			@minutes = (@seconds / 60).to_i
			@seconds = (@seconds % 60).to_i

			@totalbar = 90
			@currentbar = @totalbar - (tasklog.totalbar - tasklog.currentbar)
			@issue = (tasklog.nextgameid.to_i-1).to_s

			@grid = Grid.find_by_gameid(@issue)
			Rails.logger.debug @issue
			Rails.logger.debug @grid
		end
		
		if @minutes and @minutes < 0
			@minutes = 9
		end

		@gridlogs = Grid.last(10)

		if session.has_key?(:userid) and session[:userid] != 0
			@user = User.find(session[:userid])
		end
	end
end
