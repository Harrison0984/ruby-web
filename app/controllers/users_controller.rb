class UsersController < ApplicationController
	layout "manage"
	def new
		if isadmin(session[:userid]) > 0
			@admin = User.find(session[:userid])
			@user = User.new
		end
	end
	
	def create

		level = isadmin(session[:userid])

		if level != 0		
			admin = User.find(session[:userid])
			if level == 2
				if admin.coin > params[:user][:coin].to_i
					newCoin = admin.coin - params[:user][:coin].to_i
					admin.update(coin: newCoin)
				else
					render 'new'
				end
			end

			@user = User.new(params.require(:user).permit(:account, :password, 
				:nickname, :coin, :level, :lowerlimit, :upperlimit, :regionid, :action))
			@user.action = 1
			@user.regionid = session[:userid]

			if @user.save
				curtime = Time.new
				@operlog = Operlog.new()

				@operlog.maname = admin.account
				@operlog.username = @user.account
				@operlog.coin = @user.coin
				@operlog.action = '添加用户'
				@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				@operlog.save

				redirect_to :action => 'index'
			else
				render 'new'
			end
		else
			render 'new'
		end
	end
	
	def index
		if isadmin(session[:userid]) == 0
			redirect_to url_for(:controller => :main, :action => :index)
		else
			@admin = User.find(session[:userid])
			if @admin.level == 1
				@users = User.all
			else
				@users = User.where("regionid = ?", @admin.id)
			end
		end
	end

	def isadmin (userid)
		if session.has_key?(:userid) == false || session[:userid] == 0
			return 0
		else
			@user = User.find(session[:userid])
			if @user == nil
				return 0
			else
				return @user.level
			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		level = isadmin(session[:userid])

		if level != 0

			@user = User.find(params[:id])
			changeCoin = @user.coin - params[:user][:coin].to_i
			admin = User.find(session[:userid])

			if level == 2
				if admin.coin > changeCoin
					admin.update(coin: admin.coin+changeCoin)
				else
					render 'idnex'
				end
			end

			if @user.update(params.require(:user).permit(:password, 
				:nickname, :coin, :upperlimit, :lowerlimit, :action))

				curtime = Time.new
				@operlog = Operlog.new()
				@operlog.maname = admin.account
				@operlog.username = @user.account
				@operlog.coin = changeCoin
				if changeCoin != 0
					@operlog.action = '修改金币'
				else
					@operlog.action = '修改资料'
				end
				@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				@operlog.save

				redirect_to :action => 'index'
			else
				render 'edit'
			end
		end
	end

	def destroy
		if isadmin(session[:userid]) == 1
			@user = User.find(params[:id])
			@user.destroy

			curtime = Time.new
			@operlog = Operlog.new()
			admin = User.find(session[:userid])
			@operlog.maname = admin.account
			@operlog.username = @user.account
			@operlog.coin = -@user.coin
			@operlog.action = '删除用户'
			@operlog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

			@operlog.save

			redirect_to users_path
		end
	end

	def child
		user = User.find(params[:format])
		if user
			@child = User.where("regionid = ?", user.id)
		end
	end

	def freeze
		user = User.find(params[:format])
		if user
			if user.level > 1
				User.where("regionid = ?", user.id).each do |childuser|
					childuser.update(action: 0)
				end
			end

			user.update(action: 0)
		end

		redirect_to users_path
	end

	def unfreeze
		user = User.find(params[:format])
		if user
			if user.level > 1
				User.where("regionid = ?", user.id).each do |childuser|
					childuser.update(action: 1)
				end
			end

			user.update(action: 1)
		end

		redirect_to users_path
	end
end
