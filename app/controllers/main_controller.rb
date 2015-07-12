require 'rufus-scheduler'

class MainController < ApplicationController
	def index

		if session[:userid] != 0
			@user = User.find(session[:userid])
		end
	end
end
