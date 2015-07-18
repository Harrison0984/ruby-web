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

	def single
	end

	def combination
		taskinfo = Tasklog.last
		seconds = (taskinfo.nexttime - Time.new).to_i
		totalcoin = (params[:tracelogs][:coin1].to_i + params[:tracelogs][:coin2].to_i +
					 params[:tracelogs][:coin3].to_i + params[:tracelogs][:coin4].to_i + 
					 params[:tracelogs][:coin5].to_i + params[:tracelogs][:coin6].to_i) *
					(params[:tracelogs][:flag1_1].to_i + params[:tracelogs][:flag1_2].to_i +
					params[:tracelogs][:flag1_3].to_i + params[:tracelogs][:flag2_1].to_i +
					params[:tracelogs][:flag2_2].to_i + params[:tracelogs][:flag2_3].to_i +
					params[:tracelogs][:flag3_1].to_i + params[:tracelogs][:flag3_2].to_i +
					params[:tracelogs][:flag3_3].to_i + params[:tracelogs][:flag4_1].to_i +
					params[:tracelogs][:flag4_2].to_i + params[:tracelogs][:flag4_3].to_i +
					params[:tracelogs][:flag5_1].to_i + params[:tracelogs][:flag5_2].to_i +
					params[:tracelogs][:flag5_3].to_i + params[:tracelogs][:flag6_1].to_i +
					params[:tracelogs][:flag6_2].to_i + params[:tracelogs][:flag6_3].to_i)
		user = User.find(session[:userid])
		if seconds > 60 and user and user.coin > totalcoin

			curtime = Time.new

			if params[:tracelogs][:flag1_1].to_i > 0 or params[:tracelogs][:flag1_2].to_i > 0 or params[:tracelogs][:flag1_3].to_i > 0
				if params[:tracelogs][:coin1].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 1
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = session[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag1_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin1]
						tracelog.save
					end
					if params[:tracelogs][:flag1_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin1]
						tracelog.save
					end
					if params[:tracelogs][:flag1_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin1]
						tracelog.save
					end
				end
			end

			if params[:tracelogs][:flag2_1].to_i > 0 or params[:tracelogs][:flag2_2].to_i > 0 or params[:tracelogs][:flag2_3].to_i > 0
				if params[:tracelogs][:coin2].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 2
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = session[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag2_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin2]
						tracelog.save
					end
					if params[:tracelogs][:flag2_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin2]
						tracelog.save
					end
					if params[:tracelogs][:flag2_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin2]
						tracelog.save
					end
				end
			end

			if params[:tracelogs][:flag3_1].to_i > 0 or params[:tracelogs][:flag3_2].to_i > 0 or params[:tracelogs][:flag3_3].to_i > 0
				if params[:tracelogs][:coin3].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 3
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = session[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag3_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin3]
						tracelog.save
					end
					if params[:tracelogs][:flag3_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin3]
						tracelog.save
					end
					if params[:tracelogs][:flag3_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin3]
						tracelog.save
					end
				end
			end

			if params[:tracelogs][:flag4_1].to_i > 0 or params[:tracelogs][:flag4_2].to_i > 0 or params[:tracelogs][:flag4_3].to_i > 0
				if params[:tracelogs][:coin4].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 4
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = session[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag4_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin4]
						tracelog.save
					end
					if params[:tracelogs][:flag4_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin4]
						tracelog.save
					end
					if params[:tracelogs][:flag4_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin4]
						tracelog.save
					end
				end
			end

			if params[:tracelogs][:flag5_1].to_i > 0 or params[:tracelogs][:flag5_2].to_i > 0 or params[:tracelogs][:flag5_3].to_i > 0
				if params[:tracelogs][:coin5].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 5
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = sessiofn[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag5_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin5]
						tracelog.save
					end
					if params[:tracelogs][:flag5_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin5]
						tracelog.save
					end
					if params[:tracelogs][:flag5_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin5]
						tracelog.save
					end
				end
			end

			if params[:tracelogs][:flag6_1].to_i > 0 or params[:tracelogs][:flag6_2].to_i > 0 or params[:tracelogs][:flag6_3].to_i > 0
				if params[:tracelogs][:coin6].to_i > 0
					tracelog = Tracelog.new
					tracelog.pos = 6
					tracelog.maintype = 1
					tracelog.userid = session[:userid]

					tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
					tracelog.gameid = taskinfo.nextgameid
					tracelog.status = 0
					tracelog.useraccount = sessiofn[:account]

					tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

					if params[:tracelogs][:flag6_1] > 0
						tracelog.gametype = 1
						tracelog.coin = params[:tracelogs][:coin6]
						tracelog.save
					end
					if params[:tracelogs][:flag6_2] > 0
						tracelog.gametype = 2
						tracelog.coin = params[:tracelogs][:coin6]
						tracelog.save
					end
					if params[:tracelogs][:flag6_3] > 0
						tracelog.gametype = 3
						tracelog.coin = params[:tracelogs][:coin6]
						tracelog.save
					end
				end
			end

			user.update(coin: user.coin-totalcoin)
		end

		redirect_to url_for(:controller => :tracelogs, :action => :index)
	end
end
