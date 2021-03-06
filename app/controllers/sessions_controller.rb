class SessionsController < ApplicationController
	layout "welcome"

	def new
	end

	def create

			params[:captcha] = params[:session][:captcha];
			params[:captcha_key] = params[:session][:captcha_key];
		
			if simple_captcha_valid?
				loginlog = Loginlog.new
				curtime = Time.new
				loginlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

				useraccount = params[:session][:account]
				userpassword = params[:session][:password]
				@user = User.find_by_account(useraccount)

				if @user and @user.password == userpassword and @user.action == 1
					session[:account] = useraccount

					loginlog.username = useraccount
					loginlog.action = 1
					loginlog.save

		        	session[:userid] = @user.id
		        	if @user.level == 1
		        		redirect_to url_for(:controller => :manage, :action => :index)
		        	else
						redirect_to url_for(:controller => :main, :action => :index)
					end
				else

					loginlog.username = useraccount
					loginlog.action = -1
					loginlog.save

					@error = "无效的用户名或密码"
					@defaultname = {:account => useraccount}
					render :template => 'welcome/index'
      			end
			else
				@error = "验证码错误"
				@defaultname = {:account => useraccount}
				render :template => 'welcome/index'
			end


	end

	def destroy

		if session[:userid] != 0
			loginlog = Loginlog.new
			user = User.find(session[:userid])
			loginlog.username = user.account
			loginlog.action = 0

			curtime = Time.new
			loginlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
			loginlog.save

			session[:userid] = 0
			redirect_to url_for(:controller => :welcome, :action => :index)
		end
	end
end
