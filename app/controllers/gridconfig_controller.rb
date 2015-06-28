class GridconfigController < ApplicationController
	layout "manage"

	def index
		@gridconfigs = Gridconfig.all
	end

	def edit
		@gridconfig = Gridconfig.find(params[:id])
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
