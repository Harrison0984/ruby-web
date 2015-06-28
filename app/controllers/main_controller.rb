require 'rufus-scheduler'

class MainController < ApplicationController
	def index
		if session.has_key?(:userid) == false || session[:userid] == 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end

	def show
	end
end
