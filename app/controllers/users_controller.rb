class UsersController < ApplicationController
	layout "manage"
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
	end
	
	def create
		@user = User.new(params.require(:user).permit(:account, :password, :nickname, :coin, :level))

		if @user.save
			curtime = Time.new
			@operlog = Operlog.new()
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
	
	def index
		@users = User.all
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		coin = @user.coin

		if @user.update(params.require(:user).permit(:password, :nickname, :coin))

			curtime = Time.new
			@operlog = Operlog.new()
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

	def destroy
		@user = User.find(params[:id])
		@user.destroy

		curtime = Time.new
		@operlog = Operlog.new()
		@operlog.username = @user.account
		@operlog.coin = -@user.coin
		@operlog.action = '删除'
		@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
		@operlog.save

		redirect_to users_path
	end
end
