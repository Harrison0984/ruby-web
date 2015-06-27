class SessionsController < ApplicationController
	layout "welcome"

	def new
	end

	def create
		useraccount = params[:session][:account]
		userpassword = params[:session][:password]
		@user = User.find_by_account(useraccount)
		if @user && @user.password == userpassword
        	session[:userid] = @user.id
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@error = "Incorrect username or password."
			@defaultname = {:account => useraccount}
			render :template => 'welcome/index'
      	end
	end

	def destroy
	end
end
