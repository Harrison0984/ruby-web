class TraceresultController < ApplicationController
	layout "main"

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
			@gridlogs = Tracelog.where("time > ? and userid = ?", (curtime - 60*60).strftime("%Y-%m-%d %H:%M"), session[:userid])
		end

		if @minutes and @minutes < 0
			@minutes = 9
		end

		if session.has_key?(:userid) and session[:userid] != 0
			@user = User.find(session[:userid])
		end
	end
end
