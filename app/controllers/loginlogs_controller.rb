class LoginlogsController < ApplicationController
	layout "manage"
	def index
		@admin = User.find(session[:userid])
		@loginlogs = Loginlog.all
	end
end
