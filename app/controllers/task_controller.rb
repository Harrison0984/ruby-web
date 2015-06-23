class TaskController < ApplicationController
	layout "manage"
	
	def index
		@log = Tasklog.find_by_id(1)
	end
end
