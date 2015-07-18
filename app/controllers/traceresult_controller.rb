class TraceresultController < ApplicationController
	layout "main"

	def index
		curtime = Time.new
		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		if tasklog
			@seconds = tasklog.nexttime - curtime - 8 * 3600
			@minutes = (@seconds / 60).to_i
			@seconds = (@seconds % 60).to_i

			@currentbar = tasklog.currentbar
			tsktime = Time.parse(tasklog.runtime.to_s)
			@issue = tsktime.strftime("%Y%m%d")+(tasklog.currentbar).to_s

			@grid = Grid.find_by_gameid(@issue)
			@gridlogs = Tracelog.where("time > ?", (curtime - 60*60).strftime("%Y-%m-%d %H:%M"))
		end

		if session.has_key?(:userid) and session[:userid] != 0
			@user = User.find(session[:userid])
		end
	end
end
