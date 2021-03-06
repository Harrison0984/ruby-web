class LoginlogsController < ApplicationController
	layout "manage"
	def index
		@admin = User.find(session[:userid])
		if @admin.level == 1
			@loginlogs = Loginlog.all
		elsif @admin.level == 2
			users = User.where("regionid = ?", @admin.id)
			@loginlogs = Loginlog.where(username: users)
		end
	end
end
