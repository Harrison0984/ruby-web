class ManageController < ApplicationController
	def index
		if session.has_key?(:userid) == false || session[:userid] == 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		else
			@user = User.find(session[:userid])
			if @user == nil || @user.level != 1
				redirect_to url_for(:controller => :welcome, :action => :index)
			end
		end
	end
end
