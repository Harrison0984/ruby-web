class TracelogsController < ApplicationController
	layout "manage"

	def index

		@tracelogs = Tracelog.all
	end

	def create

		taskinfo = Tasklog.last
		seconds = (taskinfo.nexttime - Time.new).to_i
		if seconds > 15

			gridinfo = Grid.last
			nextid = gridinfo.id+1

			config = Gridconfig.find_by_gridtype(params[:traceslogs][:gametype])
			user = User.find(session[:userid])
			if config != nil and gridinfo != nil and user != nil

				newcoin = user.coin - params[:traceslogs][:coin].to_i

				if newcoin >= 0

					@tracelog = Tracelog.new(params.require(:traceslogs).permit(:pos, :gametype, :coin))
					@tracelog.userid = session[:userid]

					@tracelog.mulbability = config.mulbability
					@tracelog.gameid = nextid
					@tracelog.status = 0
					@tracelog.userid = 2
					@tracelog.useraccount = session[:account]
					@tracelog.action = 0

					curtime = Time.new
					@tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
					@tracelog.save
					user.update(coin: newcoin)

					@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
				end
			end
		end

		respond_to do |format|
            format.js {}
        end
	end

	def commitdata

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
		@tracelogs.each do |log|
			log.update(action: 1)
		end

		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
	end

	def canceldata

		refundcoin = 0
		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
		@tracelogs.each do |log|
			refundcoin += log.coin
			log.destroy
		end

		user = User.find(session[:userid])
		if user != nil
			newcoin = user.coin + refundcoin
			user.update(coin: newcoin)
		end
		@tracelogs = Tracelog.where("action != 1 and userid = ?", session[:userid])
	end
end
