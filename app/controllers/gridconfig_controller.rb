class GridconfigController < ApplicationController
	layout "manage"

	def index
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			@gridconfigs = Gridconfig.all
		end
	end

	def edit
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			if @admin.level != 1
				redirect_to :action => 'index'
			else
				@gridconfig = Gridconfig.find(params[:id])
			end
		end
	end

	def update

		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@gridconfig = Gridconfig.find(params[:id])

			if @gridconfig.update(params.permit(:id, :probability, :mulbability))
				redirect_to :action => 'index'
			else
				render 'edit'
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
