require 'rufus-scheduler'

class MainController < ApplicationController
	def index
		if session.has_key?(:userid) and session[:userid] != 0

			curtime = Time.new
			tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
			if tasklog
				@seconds = tasklog.nexttime - curtime - 8 * 3600
				@minutes = (@seconds / 60).to_i
				@seconds = (@seconds % 60).to_i

				@currentbar = tasklog.currentbar
				tsktime = Time.parse(tasklog.runtime.to_s)
				@issue = tsktime.strftime("%Y%m%d%H%M")+(tasklog.currentbar).to_s

				Rails.logger.debug @issue

				@grid = Grid.find_by_gameid(@issue)
			end

			@user = User.find(session[:userid])
		end
	end
end
