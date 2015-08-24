require 'rubygems'
require 'rufus-scheduler'
# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.new

#current task index
objindex = 0 

#
left_count = 0
begin_count = 0

#day coin
totalcoin = 0

def randomGrid

	object = []
	for i in 0..8 do
		begin
			srand()
			idx = rand(52)+1
		end while idx%13 >= 2 and idx%13 < 9

		object[i] = idx
	end

	return object
end

def processprize (userid, coin)
	user = User.find(userid)
	if user != nil
		tmpcoin = user.coin + coin
		user.update(coin: tmpcoin.to_i)
	else
		Rails.logger.error "can't find user #{userid}"
	end
end

def cardnum(num)
	if num%13 == 1
		return 14
	elsif num%13 == 0
		return 13
	else
		return num%13
	end
end

def checkGrid (object)

	lssame = []
	lsorder = []
	lsdouble = []
	lscolor = []

	#all same
	for i in 0..2
		if object[i*3]%13 == object[i*3+1]%13 and object[i*3+1]%13 == object[i*3+2]%13
			lssame[lssame.length] = i+1
		end
		if object[i]%13 == object[i+3]%13 and object[i+3]%13 == object[i+6]%13
			lssame[lssame.length] = i+4
		end
	end

	#all order
	for i in 0..2

		cards = [cardnum(object[i*3]), cardnum(object[i*3+1]), cardnum(object[i*3+2])]

		small = cards.min
		big = cards.max
		if big-small == 2 and cards[0] != cards[1] and cards[1] != cards[2] and cards[0] != cards[2]
			lsorder[lsorder.length] = i+1
		end

		cards = [cardnum(object[i]), cardnum(object[i+3]), cardnum(object[i+6])]
		small = cards.min
		big = cards.max
		if big-small == 2 and cards[0] != cards[1] and cards[1] != cards[2] and cards[0] != cards[2]
			lsorder[lsorder.length] = i+4
		end
	end

	#all double
	for i in 0..2
		if object[i*3]%13 == object[i*3+1]%13 or object[i*3+1]%13 == object[i*3+2]%13 or object[i*3]%13 == object[i*3+2]%13
			lsdouble[lsdouble.length] = i+1
		end
		if object[i]%13 == object[i+3]%13 or object[i+3]%13 == object[i+6]%13 or object[i]%13 == object[i+6]%13
			lsdouble[lsdouble.length] = i+4
		end
	end

	#same color
	for i in 0..2
		if object[i*3] <= 13 and object[i*3+1] <= 13 and object[i*3+2] <= 13
			lscolor[lscolor.length] = i+1
		end
		if object[i] <= 13 and object[i+3] <= 13 and object[i+6] <= 13
			lscolor[lscolor.length] = i+4
		end

		if object[i*3] >= 14 and object[i*3] <= 26 and object[i*3+1] <= 14 and object[i*3+1] <= 26 and object[i*3+2] >= 14 and object[i*3+2] <= 26
			lscolor[lscolor.length] = i+1
		end
		if object[i] >= 14 and object[i] <= 26 and object[i+3] <= 14 and object[i+3] <= 26 and object[i+6] >= 14 and object[i+6] <= 26
			lscolor[lscolor.length] = i+4
		end
		
		if object[i*3] >= 27 and object[i*3+1] >= 27 and object[i*3+2] >= 27
			lscolor[lscolor.length] = i+1
		end
		if object[i] >= 27 and object[i+3] >= 27 and object[i+6] >= 27
			lscolor[lscolor.length] = i+4
		end
	end

	return lssame,lsorder,lsdouble,lscolor
end

s.cron '00 02 * * *', :first_at => Time.now + 1 do

	admin = User.find_by_level(1)
	if admin == nil
		user = User.new
		user.account = "admin"
		user.password = "123"
		user.nickname = "管理员"
		user.regionname = "admin"
		user.action = 1
		user.lowerlimit = 1
		user.upperlimit = 10000
		user.everylimit = 10000
		user.todaycoin = 0
		user.coin = 1000000
		user.level = 1
		user.save
	end

	for i in 1..8
		gridconfig = Gridconfig.find_by_gridtype(i)
		if gridconfig == nil
			gridconfig = Gridconfig.new
			gridconfig.gridtype = i
			gridconfig.probability = 1.0
			gridconfig.mulbability = 2.0
			gridconfig.save
		end
	end
end

s.cron '56 09 * * *', :first_at => Time.now + 1, :timeout => '30m' do

	#left count of day
	if Time.now.hour < 9
		left_count = ((Time.now.beginning_of_day+60*60 - Time.now) / 600).to_i
	else
		left_count = ((Time.now.tomorrow.beginning_of_day+60*60 - Time.now) / 600).to_i
	end

	if left_count > 0
		totalcoin = 0
		begin_count = 90 - left_count

		objindex = 0
	end
end

s.cron '*/10 * * * *' do

	if Time.new.hour >= 1 and Time.new.hour < 10
		Rails.logger.debug "invalid time"
	else
		Rails.logger.debug "start task"
		curtime = Time.new

		globalgrid = 0
		grid = Grid.new
		grid.gameid = curtime.strftime("%Y%m%d")+(begin_count+objindex+1).to_s.rjust(2, '0')

		begin
			localcoin = (totalcoin).abs * 0.8
			Rails.logger.debug localcoin
			localgrid = randomGrid
			prizetotal = 0
			lssame, lsorder, lsdouble, lscolor = checkGrid(localgrid)
			
			Tracelog.where("gameid = ? and maintype = 1", grid.gameid).each do |log|
				localcoin += log.coin
	  			if log.gametype == 1 and lssame.include?(log.pos)
	  				prizetotal += log.coin * log.mulbability
	  			elsif log.gametype == 2 and lscolor.include?(log.pos)
	  				prizetotal += log.coin * log.mulbability
	  			elsif log.gametype == 3 and lsorder.include?(log.pos)
	  				prizetotal += log.coin * log.mulbability
	  			elsif log.gametype == 4 and lsdouble.include?(log.pos)
	  				prizetotal += log.coin * log.mulbability
	  			end
			end

			#single
			Tracelog.where("gameid = ? and maintype = 2", grid.gameid).each do |log|
				localcoin += log.coin
				if log.gametype == 1 and localgrid[log.pos-1]%13 == 1
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 2 and localgrid[log.pos-1]%13 == 9
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 3 and localgrid[log.pos-1]%13 == 10
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 4 and localgrid[log.pos-1]%13 == 11
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 5 and localgrid[log.pos-1]%13 == 12
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 6 and localgrid[log.pos-1]%13 == 0
					prizetotal += log.coin * log.mulbability
				end
			end

			#double
			Tracelog.where("gameid = ? and maintype = 3", grid.gameid).each do |log|
				localcoin += log.coin
				if log.gametype == 1 and (localgrid[log.pos-1]%13 == 1 or localgrid[log.pos-1]%13 == 12 or localgrid[log.pos-1]%13 == 0)
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 2 and localgrid[log.pos-1]%13 == 11 and localgrid[log.pos-1]%13 == 10 and localgrid[log.pos-1]%13 == 9
					prizetotal += log.coin * log.mulbability
				end
			end

			#card class
			Tracelog.where("gameid = ? and maintype = 4", grid.gameid).each do |log|
				localcoin += log.coin
				if log.gametype == 1 and localgrid[log.pos-1] <= 13
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 2 and localgrid[log.pos-1] > 13 and localgrid[log.pos-1] <= 26
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 3 and localgrid[log.pos-1] > 26 and localgrid[log.pos-1] <= 39
					prizetotal += log.coin * log.mulbability
				elsif log.gametype == 4 and localgrid[log.pos-1] > 39
					prizetotal += log.coin * log.mulbability
				end
			end

			localcoin -= prizetotal
			Rails.logger.debug prizetotal
			Rails.logger.debug localcoin

			if localcoin >= 0 then
				globalgrid = localgrid
				totalcoin += localcoin
				break
			end
		end while true

################################################################################################################################################################
		
		grid.x1 = globalgrid[0]
		grid.x2 = globalgrid[1]
		grid.x3 = globalgrid[2]
		grid.y1 = globalgrid[3]
		grid.y2 = globalgrid[4]
		grid.y3 = globalgrid[5]
		grid.z1 = globalgrid[6]
		grid.z2 = globalgrid[7]
		grid.z3 = globalgrid[8]
		grid.time = curtime.strftime("%Y-%m-%d %H:%M")

		Rails.logger.debug grid
		grid.save

		#start user prize
		lssame, lsorder, lsdouble, lscolor = checkGrid(globalgrid)
		prizecoin = 0;

		Tracelog.where("gameid = ? and maintype = 1", grid.gameid).each do |log|
  			if log.gametype == 1 and lssame.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			elsif log.gametype == 2 and lscolor.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			elsif log.gametype == 3 and lsorder.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			elsif log.gametype == 4 and lsdouble.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			else
  				log.update(status: -1)
  			end
		end

		#single
		Tracelog.where("gameid = ? and maintype = 2", grid.gameid).each do |log|
			if log.gametype == 1 and globalgrid[log.pos-1]%13 == 1
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 2 and globalgrid[log.pos-1]%13 == 9
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 3 and globalgrid[log.pos-1]%13 == 10
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 4 and globalgrid[log.pos-1]%13 == 11
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 5 and globalgrid[log.pos-1]%13 == 12
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 6 and globalgrid[log.pos-1]%13 == 0
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			else
				log.update(status: -1)
			end
		end

		#double
		Tracelog.where("gameid = ? and maintype = 3", grid.gameid).each do |log|
			if log.gametype == 1 and (globalgrid[log.pos-1]%13 == 1 or globalgrid[log.pos-1]%13 == 12 or globalgrid[log.pos-1]%13 == 0)
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 2 and globalgrid[log.pos-1]%13 == 11 and globalgrid[log.pos-1]%13 == 10 and globalgrid[log.pos-1]%13 == 9
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			else					
				log.update(status: -1)
			end
		end

		#card class
		Tracelog.where("gameid = ? and maintype = 4", grid.gameid).each do |log|
			if log.gametype == 1 and globalgrid[log.pos-1] <= 13
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 2 and globalgrid[log.pos-1] > 13 and globalgrid[log.pos-1] <= 26
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 3 and globalgrid[log.pos-1] > 26 and globalgrid[log.pos-1] <= 39
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 4 and globalgrid[log.pos-1] > 39
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			else
				log.update(status: -1)
			end
		end

		#if the end time of day
		if curtime.hour == 0 and curtime.min == 50
			nexttime = curtime.beginning_of_day + 10*60*60+10*60
		else
			nexttime = curtime + 10*60
		end

		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		Rails.logger.debug tasklog
		if tasklog == nil
			tasklog = Tasklog.new
			tasklog.totalbar = left_count
			tasklog.currentbar = objindex+1
			tasklog.totalcoin = totalcoin
			tasklog.prizecoin = prizecoin
			tasklog.taskdate = curtime.strftime("%Y-%m-%d")
			tasklog.runtime = curtime.strftime("%H:%M")
			tasklog.nexttime = nexttime.strftime("%Y-%m-%d %H:%M")
			tasklog.nextgameid = curtime.strftime("%Y%m%d")+(begin_count+objindex+2).to_s.rjust(2, '0')
			tasklog.save
		else
			tasklog.update(totalbar: left_count, currentbar: objindex+1, totalcoin: totalcoin, 
				prizecoin: prizecoin, runtime: curtime.strftime("%H:%M"),
				nextgameid: curtime.strftime("%Y%m%d")+(begin_count+objindex+2).to_s.rjust(2, '0'),
				nexttime: nexttime.strftime("%Y-%m-%d %H:%M"))
		end

		objindex += 1
	end
end