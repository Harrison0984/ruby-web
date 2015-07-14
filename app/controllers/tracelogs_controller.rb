class TracelogsController < ApplicationController
	layout "manage"

	def index
		@admin = User.find(session[:userid])
		if @admin.level == 1
			@tracelogs = Tracelog.all
		else
			users = User.where("regionid = ?", @admin.id)
			@tracelogs = Tracelog.where(userid: users)
		end
	end

	def create

		taskinfo = Tasklog.last
		seconds = (taskinfo.nexttime - Time.new - 8 * 3600).to_i
		if seconds > 60

			gridinfo = Grid.last
			nextid = gridinfo.id+1
			config = Gridconfig.find_by_gridtype(params[:traceslogs][:gametype])

			if config != nil and gridinfo != nil

				@tracelog = Tracelog.new(params.require(:traceslogs).permit(:pos, :maintype, :gametype, :coin))
				@tracelog.userid = session[:userid]

				@tracelog.mulbability = config.mulbability
				@tracelog.gameid = nextid
				@tracelog.status = 0
				@tracelog.useraccount = session[:account]

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
end
