class TracelogsController < ApplicationController
	layout "manage"

	def index
		if session[:userid] != nil and session[:userid] != 0
			@admin = User.find(session[:userid])
			if @admin.level == 1
				@tracelogs = Tracelog.all
			elsif @admin.level == 2
				users = User.where("regionname = ?", @admin.account)
				@tracelogs = Tracelog.where(userid: users)
			end
		end
	end

	def double
		if session[:userid] != nil and session[:userid] != 0
			taskinfo = Tasklog.last
			seconds = (taskinfo.nexttime - Time.new).to_i
			totalcoin = params[:tracelogs][:totalcoin].to_i
			user = User.find(session[:userid])
			
			@result = Array.new
			@totalcoin = 0
			@gameid = taskinfo.nextgameid

			if seconds > 60 and user and user.coin > totalcoin
				@totalcoin = totalcoin
				curtime = Time.new
				for i in 1..9
					if params[:tracelogs]["flag#{i}_1"].to_i > 0 or params[:tracelogs]["flag#{i}_2"].to_i > 0 or 
						params[:tracelogs]["flag#{i}_3"].to_i > 0
						if params[:tracelogs]["flag#{i}_1"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 3
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(5).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.gametype = 1
							tracelog.coin = params[:tracelogs]["flag#{i}_1"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_2"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 3
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(6).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.gametype = 2
							tracelog.coin = params[:tracelogs]["flag#{i}_2"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
					end
				end
				user.update(coin: user.coin-totalcoin)
			end
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		else
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		end
	end

	def single
		if session[:userid] != nil and session[:userid] != 0
			taskinfo = Tasklog.last
			seconds = (taskinfo.nexttime - Time.new).to_i
			totalcoin = params[:tracelogs][:totalcoin].to_i
			user = User.find(session[:userid])

			@result = Array.new
			@totalcoin = 0
			@gameid = taskinfo.nextgameid

			if seconds > 60 and user and user.coin > totalcoin
				@totalcoin = totalcoin
				curtime = Time.new

				for i in 1..9
					if params[:tracelogs]["flag#{i}_1"].to_i > 0 or params[:tracelogs]["flag#{i}_2"].to_i > 0 or 
						params[:tracelogs]["flag#{i}_3"].to_i > 0 or params[:tracelogs]["flag#{i}_4"].to_i > 0 or
						params[:tracelogs]["flag#{i}_5"].to_i > 0 or params[:tracelogs]["flag#{i}_6"].to_i > 0 or
						params[:tracelogs]["flag#{i}_7"].to_i > 0 or params[:tracelogs]["flag#{i}_8"].to_i > 0 or
						params[:tracelogs]["flag#{i}_9"].to_i > 0 or params[:tracelogs]["flag#{i}_10"].to_i > 0 or
						params[:tracelogs]["flag#{i}_11"].to_i > 0 or params[:tracelogs]["flag#{i}_12"].to_i > 0 or
						params[:tracelogs]["flag#{i}_13"].to_i > 0
						if params[:tracelogs]["flag#{i}_1"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.gametype = 1
							tracelog.coin = params[:tracelogs]["flag#{i}_1"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_2"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.gametype = 2
							tracelog.coin = params[:tracelogs]["flag#{i}_2"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_3"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 3
							tracelog.coin = params[:tracelogs]["flag#{i}_3"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_4"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 4
							tracelog.coin = params[:tracelogs]["flag#{i}_4"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_5"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 5
							tracelog.coin = params[:tracelogs]["flag#{i}_5"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_6"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 2
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(7).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 6
							tracelog.coin = params[:tracelogs]["flag#{i}_6"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_8"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 4
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(8).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 1
							tracelog.coin = params[:tracelogs]["flag#{i}_8"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_9"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 4
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(8).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 2
							tracelog.coin = params[:tracelogs]["flag#{i}_9"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_10"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 4
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(8).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 3
							tracelog.coin = params[:tracelogs]["flag#{i}_10"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_11"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 4
							tracelog.userid = session[:userid]

							tracelog.mulbability = Gridconfig.find_by_gridtype(8).mulbability
							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
							
							tracelog.gametype = 4
							tracelog.coin = params[:tracelogs]["flag#{i}_11"]
							tracelog.save
							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
								"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
					end
				end

				user.update(coin: user.coin-totalcoin)
			end
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		else
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		end
	end

	def combination
		if session[:userid] != nil and session[:userid] != 0
			taskinfo = Tasklog.last
			seconds = (taskinfo.nexttime - Time.new).to_i
			totalcoin = params[:tracelogs][:totalcoin].to_i
			user = User.find(session[:userid])

			@result = Array.new
			@totalcoin = totalcoin
			@gameid = taskinfo.nextgameid

			if seconds > 60 and user and user.coin > totalcoin
				@totalcoin = totalcoin
				curtime = Time.new
				for i in 1..6
					if params[:tracelogs]["flag#{i}_1"].to_i > 0 or params[:tracelogs]["flag#{i}_2"].to_i > 0 or params[:tracelogs]["flag#{i}_3"].to_i > 0 or params[:tracelogs]["flag#{i}_4"].to_i > 0
						if params[:tracelogs]["flag#{i}_1"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 1
							tracelog.userid = session[:userid]

							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.mulbability = Gridconfig.find_by_gridtype(1).mulbability
							tracelog.gametype = 1
							tracelog.coin = params[:tracelogs]["flag#{i}_1"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
									"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_2"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 1
							tracelog.userid = session[:userid]

							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.mulbability = Gridconfig.find_by_gridtype(2).mulbability
							tracelog.gametype = 2
							tracelog.coin = params[:tracelogs]["flag#{i}_2"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
									"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_3"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 1
							tracelog.userid = session[:userid]

							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.mulbability = Gridconfig.find_by_gridtype(3).mulbability
							tracelog.gametype = 3
							tracelog.coin = params[:tracelogs]["flag#{i}_3"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
									"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
						if params[:tracelogs]["flag#{i}_4"].to_i > 0
							tracelog = Tracelog.new
							tracelog.pos = i
							tracelog.maintype = 1
							tracelog.userid = session[:userid]

							tracelog.gameid = taskinfo.nextgameid
							tracelog.status = 0
							tracelog.useraccount = session[:account]

							tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")

							tracelog.mulbability = Gridconfig.find_by_gridtype(4).mulbability
							tracelog.gametype = 4
							tracelog.coin = params[:tracelogs]["flag#{i}_4"]
							tracelog.save

							@result[@result.length] = {"pos"=>i,"gametype"=>tracelog.gametype,
									"maintype"=>tracelog.maintype,"coin"=>tracelog.coin}
						end
					end
				end
				user.update(coin: user.coin-totalcoin)
			end
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		else
			respond_to do |format|
				format.html {}
				format.js {}
				format.json {}
			end
		end
	end
end
