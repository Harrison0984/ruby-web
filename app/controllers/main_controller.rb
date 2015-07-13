require 'rufus-scheduler'

class MainController < ApplicationController
	def index

		if session.has_key?(:userid) and session[:userid] != 0
			@user = User.find(session[:userid])
		end
	end
end
