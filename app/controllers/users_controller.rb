class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
	end
	
	def create
		@user = User.new(params.require(:user).permit(:account, :password, :nickname, :coin))

		if @user.save
			redirect_to @user
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

		if @user.update(params.require(:user).permit(:account, :password, :nickname, :coin))
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy

		redirect_to users_path
	end
end
