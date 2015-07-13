class TaskController < ApplicationController
	layout "manage"
	
	def index
		@admin = User.find(session[:userid])
		@log = Tasklog.find_by_id(1)
	end
end
