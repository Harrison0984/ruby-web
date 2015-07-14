class OperlogsController < ApplicationController
	layout "manage"
	
	def index
		@admin = User.find(session[:userid])
		if @admin.level == 1
			@operlogs = Operlog.all
		else
			users = User.where("regionid = ?", @admin.id)
			@operlogs = Operlog.where(maname: users)
		end
	end
end
