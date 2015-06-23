class TracelogsController < ApplicationController
	layout "manage"

	def index
		@tracelogs = Tracelog.all
	end
end
