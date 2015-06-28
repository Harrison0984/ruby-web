class UsersController < ApplicationController
	layout "manage"
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
	end
	
	def create
		if isadmin(session[:userid])
			@user = User.new(params.require(:user).permit(:account, :password, :nickname, :coin, :level))

			if @user.save
				curtime = Time.new
				@operlog = Operlog.new()

				admin = User.find(session[:userid])
				@operlog.maname = admin.account

				@operlog.username = @user.account
				@operlog.coin = @user.coin
				@operlog.action = '新建'
				@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				@operlog.save
				redirect_to :action => 'index'
			else
				render 'new'
			end
		end
	end
	
	def index
		if isadmin(session[:userid]) == false
			redirect_to url_for(:controller => :welcome, :action => :index)
		else
			@users = User.all
		end
	end

	def isadmin (userid)
		if session.has_key?(:userid) == false || session[:userid] == 0
			return false
		else
			@user = User.find(session[:userid])
			if @user == nil || @user.level != 1
				return false
			else
				return true
			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		if isadmin(session[:userid])
			@user = User.find(params[:id])
			coin = @user.coin

			if @user.update(params.require(:user).permit(:password, :nickname, :coin))

				curtime = Time.new
				@operlog = Operlog.new()

				admin = User.find(session[:userid])
				@operlog.maname = admin.account

				@operlog.username = @user.account
				@operlog.coin = @user.coin - coin
				@operlog.action = '修改'
				@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				@operlog.save

				redirect_to :action => 'index'
			else
				render 'edit'
			end
		end
	end

	def destroy
		if isadmin(session[:userid])
			@user = User.find(params[:id])
			@user.destroy

			curtime = Time.new
			@operlog = Operlog.new()

			admin = User.find(session[:userid])
			@operlog.maname = admin.account

			@operlog.username = @user.account
			@operlog.coin = -@user.coin
			@operlog.action = '删除'
			@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
			@operlog.save

			redirect_to users_path
		end
	end
end
