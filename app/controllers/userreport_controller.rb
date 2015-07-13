class UserreportController < ApplicationController
	layout "manage"

	def index
		@admin = User.find(session[:userid])
	end
end
