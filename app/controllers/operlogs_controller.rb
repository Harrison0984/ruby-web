class OperlogsController < ApplicationController
	layout "manage"
	
	def index
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			if @admin.level == 1
				@operlogs = Operlog.all
			elsif @admin.level == 2
				users = User.where("regionid = ?", @admin.id)
				@operlogs = Operlog.where(maname: users)
			end
		end
	end
end
