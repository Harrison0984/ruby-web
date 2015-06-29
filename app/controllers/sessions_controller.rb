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
        	if @user.level == 1
        		redirect_to url_for(:controller => :manage, :action => :index)
        	else
				redirect_to url_for(:controller => :main, :action => :index)
			end
		else
			@error = "无效的用户名或密码"
			@defaultname = {:account => useraccount}
			render :template => 'welcome/index'
      	end
	end

	def destroy
		session[:userid] = 0
		redirect_to url_for(:controller => :welcome, :action => :index)
	end
end
