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

	def isadmin (userid)
		if session.has_key?(:userid) == false || session[:userid] == 0
			return 0
		else
			@user = User.find(session[:userid])
			if @user == nil
				return 0
			else
				return @user.level
			end
		end
	end
end
