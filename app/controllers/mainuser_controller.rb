class MainuserController < ApplicationController
	layout "mainuser"
	def index
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end

	def changedetail
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end		
	end

	def changepassword
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end
end
