class GridconfigController < ApplicationController
	layout "manage"

	def index
		@admin = User.find(session[:userid])
		@gridconfigs = Gridconfig.all
	end

	def edit
		@admin = User.find(session[:userid])
		if @admin.level != 1
			redirect_to :action => 'index'
		else
			@gridconfig = Gridconfig.find(params[:id])
		end
	end

	def update
		@gridconfig = Gridconfig.find(params[:id])

		if @gridconfig.update(params.permit(:id, :probability, :mulbability))
			redirect_to :action => 'index'
		else
			render 'edit'
		end
	end
end
