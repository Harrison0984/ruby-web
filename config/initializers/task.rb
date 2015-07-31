require 'rubygems'
require 'rufus-scheduler'
# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.new

#task list
objects = Array.new(90)

#current task index
objindex = 0 
day_same = 0
day_color = 0
day_order = 0
day_small = 0
day_double = 0
day_big = 0

#
left_count = 0
begin_count = 0

def randomGrid

	object = []
	for i in 0..8 do
		begin
			srand()
			idx = rand(52)+1
		end while idx%13 >= 2 and idx%13 < 9

		object[i] = idx
	end

	lssame, lsorder, lssmall, lsbig, lsdouble, lscolor = checkGrid(object)
	return object,lssame.length,lsorder.length,lssmall.length,lsbig.length,lsdouble.length,lscolor.length
end

def processprize (userid, coin)
	user = User.find(userid)
	if user != nil
		totalcoin = user.coin + coin
		user.update(coin: totalcoin)
	else
		Rails.logger.error "can't find user #{userid}"
	end
end

def cardnum(num)
	if num%13 == 1
		return 14
	else
		return num%14
	end
end

def checkGrid (object)

	lssame = []
	lsorder = []
	lssmall = []
	lsbig = []
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

	#all big && small
	for i in 0..2
		cards = [cardnum(object[i*3]), cardnum(object[i*3+1]), cardnum(object[i*3+2])]

		if cards[0] + cards[1] + cards[2] > 31
			lsbig[lsbig.length] = i+1
		elsif cards[0] + cards[1] +cards[2] < 31
			lssmall[lssmall.length] = i+1
		end

		cards = [cardnum(object[i]), cardnum(object[i+3]), cardnum(object[i+6])]		
		if cards[0] + cards[1] + cards[2] > 31
			lsbig[lsbig.length] = i+4
		elsif cards[0] + cards[1] + cards[2] < 31
 			lssmall[lssmall.length] = i+4
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

	return lssame,lsorder,lssmall,lsbig,lsdouble,lscolor
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
			gridconfig.mulbability = 1.0
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
		begin_count = 90 - left_count

		#reset user daycoin every day at 5am
		if Time.now.hour == 5
			users = User.all
			users.each do |user|
				user.update(todaycoin: 0)
			end
		end

		objects = []
		objindex = 0
		for i in 0..left_count-1
			object, samenum, ordernum, smallnum, bignum, doublenum, colornum = randomGrid

			day_same += samenum
			day_order += ordernum
			day_small += smallnum
			day_big += bignum
			day_double += doublenum
			day_color += colornum

			objects[i] = object
		end

		Rails.logger.debug left_count
		Rails.logger.debug day_same
		Rails.logger.debug day_order
		Rails.logger.debug day_small
		Rails.logger.debug day_big
		Rails.logger.debug day_double
		Rails.logger.debug day_color

		for i in 0..left_count-1
			srand()
			index = rand(left_count)
			tmp = objects[index]
			objects[index] = objects[i]
			objects[i] = tmp
		end
	end
end

s.cron '*/10 * * * *' do

	if Time.new.hour >= 1 and Time.new.hour < 10
		Rails.logger.debug "invalid time"
	else
		Rails.logger.debug "start task"
		curtime = Time.new

		grid = Grid.new
		grid.gameid = curtime.strftime("%Y%m%d")+(begin_count+objindex+1).to_s
		grid.x1 = objects[objindex][0]
		grid.x2 = objects[objindex][1]
		grid.x3 = objects[objindex][2]
		grid.y1 = objects[objindex][3]
		grid.y2 = objects[objindex][4]
		grid.y3 = objects[objindex][5]
		grid.z1 = objects[objindex][6]
		grid.z2 = objects[objindex][7]
		grid.z3 = objects[objindex][8]

		grid.time = curtime.strftime("%Y-%m-%d %H:%M")

		Rails.logger.debug grid
		grid.save

		lssame, lsorder, lssmall, lsbig, lscolor = checkGrid(objects[objindex])

		totalcoin = 0
		prizecoin = 0
		
		Tracelog.where("gameid = ? and maintype = 1", grid.gameid).each do |log|
			totalcoin += log.coin
  			if log.gametype == 1 and lssame.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			elsif log.gametype == 2 and lsorder.include?(log.pos)
  				prizecoin = log.coin * log.mulbability
  				processprize(log.userid, prizecoin)
  				log.update(status: 1)
  			elsif log.gametype == 3 and lssmall.include?(log.pos)
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

		Tracelog.where("gameid = ? and maintype = 2", grid.gameid).each do |log|
			totalcoin += log.coin
			if object[objindex][log.pos-1] % 14 == log.gametype
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			else
				log.update(status: -1)
			end
		end

		Tracelog.where("gameid = ? and maintype = 3", grid.gameid).each do |log|
			totalcoin += log.coin
			if log.gametype == 1 and object[objindex][log.pos-1] % 14 < 7
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 2 and objindex[objindex][log.pos-1] % 14 == 7
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 3 and objindex[objindex][log.pos-1] % 14 > 7
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			else					
				log.update(status: -1)
			end
		end

		Tracelog.where("gameid = ? and maintype = 3", grid.gameid).each do |log|
			totalcoin += log.coin
			if log.gametype == 1 and object[objindex][log.pos-1] <= 13
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 2 and object[objindex][log.pos-1] > 13 and object[objindex][log.pos-1] <= 26
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 3 and object[objindex][log.pos-1] > 26 and object[objindex][log.pos-1] <= 39
				prizecoin = log.coin * log.mulbability
				processprize(log.userid, prizecoin)
				log.update(status: 1)
			elsif log.gametype == 4 and object[objindex][log.pos-1] > 39
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
			tasklog.nextgameid = curtime.strftime("%Y%m%d")+(begin_count+objindex+2).to_s
			tasklog.save
		else
			tasklog.update(totalbar: left_count, currentbar: objindex+1, totalcoin: totalcoin, 
				prizecoin: prizecoin, runtime: curtime.strftime("%H:%M"),
				nextgameid: curtime.strftime("%Y%m%d")+(begin_count+objindex+2).to_s,
				nexttime: nexttime.strftime("%Y-%m-%d %H:%M"))
		end

		objindex += 1
	end
end