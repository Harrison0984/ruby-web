class OperlogsController < ApplicationController
	layout "manage"
	
	def index
		@admin = User.find(session[:userid])
		@operlogs = Operlog.all
	end
end
