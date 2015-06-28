class WelcomeController < ApplicationController
  def index
  	@defaultname = {:account => ""}
  	if session[:userid] > 0
		redirect_to url_for(:controller => :main, :action => :index)
	end
  end
end
