class WelcomeController < ApplicationController

  def index
  	@defaultname = {:account => ""}
    session[:userid] = 0
  	if session[:userid] != nil and session[:userid] > 0
  		user = User.find(session[:userid])
      if user
    		if user.level == 1
    			redirect_to url_for(:controller => :manage, :action => :index)
    		else
  			  redirect_to url_for(:controller => :main, :action => :index)
    		end
      else
        session[:userid] = 0
        redirect_to url_for(:controller => :welcome, :action => :index)
      end
	end
  end
end
