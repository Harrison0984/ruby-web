class MainhistoryController < ApplicationController
	layout "main"

	def index
		if session[:userid] == 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		end

		@user = User.find(session[:userid])
		if @user == nil
			redirect_to url_for(:controller => :welcome, :action => :index)
		end

		@tracelogs = Tracelog.where("userid = ?", @user.id)
	end
end
