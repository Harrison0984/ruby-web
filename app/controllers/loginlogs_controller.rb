class LoginlogsController < ApplicationController
	layout "manage"
	def index
		@loginlogs = Loginlog.all
	end
end
