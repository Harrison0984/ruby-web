class ManageController < ApplicationController
	def index
		if session.has_key?(:userid) == false || session[:userid] == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			if @admin == nil || @admin.level == 0
				redirect_to url_for(:controller => :main, :action => :index)
			end
		end
	end
end
