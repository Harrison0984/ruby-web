class OperlogsController < ApplicationController
	layout "manage"
	
	def index
		@operlogs = Operlog.all
	end
end
