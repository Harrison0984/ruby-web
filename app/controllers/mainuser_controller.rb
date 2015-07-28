class MainuserController < ApplicationController
	layout "mainuser"
	def index
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end

	def changedetail
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end		
	end

	def changepassword
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end

	def updatedetail
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end

		nickname = params[:mainuser][:nickname]
		@user.update(nickname: nickname)
		render :template => 'mainuser/index'
	end

	def updatepassword
		if session[:userid] != 0
			@user = User.find(session[:userid])
		else
			redirect_to url_for(:controller => :welcome, :action => :index)
		end

		curpassword = params[:mainuser][:curpassword]
		newpassword = params[:mainuser][:newpassword]
		repassword = params[:mainuser][:repassword]
		if newpassword != repassword
			@error = "两次密码不相符，请注意区分大小写."
			render :template => 'mainuser/changepassword'
		elsif @user.password != curpassword
			@error = "当前密码错误."
			render :template => 'mainuser/changepassword'
		else
			@user.update(password: newpassword)
			render :template => 'mainuser/index'
		end
	end
end
