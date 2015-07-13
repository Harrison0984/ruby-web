class TracelogsController < ApplicationController
	layout "manage"

	def index
		@admin = User.find(session[:userid])
		@tracelogs = Tracelog.all
	end

	def create

		taskinfo = Tasklog.last
		seconds = (taskinfo.nexttime - Time.new - 8 * 3600).to_i
		if seconds > 60

			gridinfo = Grid.last
			nextid = gridinfo.id+1
			config = Gridconfig.find_by_gridtype(params[:traceslogs][:gametype])

			if config != nil and gridinfo != nil

				@tracelog = Tracelog.new(params.require(:traceslogs).permit(:pos, :gametype, :coin))
				@tracelog.userid = session[:userid]

				@tracelog.mulbability = config.mulbability
				@tracelog.gameid = nextid
				@tracelog.status = 0
				@tracelog.useraccount = session[:account]
				@tracelog.action = 0

				curtime = Time.new
				@tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				@tracelog.save
			end
		else
			seconds = 300
		end

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])

		respond_to do |format|
            format.js {}
        end
	end

	def commitdata

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])

		totalCoin = 0
		@tracelogs.each do |log|
			totalCoin += log.coin
		end

		user = User.find(session[:userid])
		if user == nil
			@error = "非法用户"
		else
			if user.coin < totalCoin
				@error = "金币不足"
			else
				user.update(coin: user.coin-totalCoin)
				@tracelogs.each do |log|
					log.update(action: 1)
				end
			end
		end

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
	end

	def canceldata

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
		@tracelogs.each do |log|
			log.destroy
		end

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
	end
end
