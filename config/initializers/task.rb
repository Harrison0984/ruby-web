require 'rubygems'
require 'rufus-scheduler'
# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.new

#task list
objects = Array.new(228)

#current task index
objindex = 0 

#do nothing
first_run = false

max_same = 0
day_same = 0
mul_same = 1.0

max_order = 0
day_order = 0
mul_order = 1.0

max_small = 0
day_small = 0
mul_small = 1.0

max_big = 0
day_big = 0
mul_big = 1.0

max_color = 0
day_color = 0
mul_color = 1.0

def randomGrid
	object = Array[rand(53),rand(53),rand(53),
					rand(53),rand(53),rand(53),
					rand(53),rand(53),rand(53)]

	lssame, lsorder, lssmall, lsbig, lscolor = checkGrid(object)

	return object,lssame.length,lsorder.length,lssmall.length,lsbig.length,lscolor.length
end

def isequal (o1, o2)
	if o1 == 0 || o2 == 0 || o1 == o2
		return true
	else
		return false
	end
end

def ismequal (o1, o2)
	if o1 == 0 || o1 >= o2
		return true
	else
		return false
	end
end

def checkGrid (object)

	lssame = []
	lsorder = []
	lssmall = []
	lsbig = []
	lscolor = []

	#all same
	for i in 0..2
		if isequal object[i*3], object[i*3+1] and isequal object[i*3+1], object[i*3+2]
			lssame[lssame.length] = i+1
		end
		if isequal object[i], object[i+3] and isequal object[i+3], object[i+6]
			lssame[lssame.length] = i+4
		end
	end

	#all order
	for i in 0..2
		if object[i*3]%13 <= 11 and isequal object[i*3]+1, object[i*3+1] and isequal object[i*3+1]+1, object[i*3+2]
			lsorder[lsorder.length] = i+1
		end
		if object[i]%13 <= 11 and isequal object[i]+1, object[i+3] and isequal object[i+3]+1, object[i+6]
			lsorder[lsorder.length] = i+4
		end
	end

	#all small
	for i in 0..2
		if object[i*3]%13 < 7 and object[i*3+1]%13 < 7 and object[i*3+2]%13 < 7
			lssmall[lssmall.length] = i+1
		end
		if object[i]%13 < 7 and object[i+3]%13 < 7 and object[i+6]%13 < 7
			lssmall[lssmall.length] = i+4
		end
	end

	#all big
	for i in 0..2
		if ismequal object[i*3]%13, 6 and ismequal object[i*3+1]%13,6 and ismequal object[i*3+2]%13, 6
			lsbig[lsbig.length] = i+1
		end
		if ismequal object[i]%13, 6 and ismequal object[i+3]%13, 6 and ismequal object[i+6]%13, 6
			lsbig[lsbig.length] = i+4
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

		if ismequal object[i*3], 14 and object[i*3] <= 26 and ismequal object[i*3+1], 14 and object[i*3+1] <= 26 and
		 ismequal object[i*3+2], 14 and object[i*3+2] <= 26
			lscolor[lscolor.length] = i+1
		end
		if ismequal object[i], 14 and object[i] <= 26 and ismequal object[i+3], 14 and object[i+3] <= 26 and
		 ismequal object[i+6], 14 and object[i+6] <= 26
			lscolor[lscolor.length] = i+4
		end
		
		if ismequal object[i*3], 27 and ismequal object[i*3+1], 27 and ismequal object[i*3+2], 27
			lscolor[lscolor.length] = i+1
		end
		if ismequal object[i], 27 and ismequal object[i+3], 27 and ismequal object[i+6], 27
			lscolor[lscolor.length] = i+4
		end
	end

	return lssame,lsorder,lssmall,lsbig,lscolor
end

s.cron '30 05 * * *', :first_at => Time.now + 1, :timeout => '30m' do

	#get game config information
	gridconfigs = Gridconfig.all
	gridconfigs.each do |config|
		if config.gridtype == 1
			max_same = config.probability*228
			mul_same = config.mulbability
		elsif config.gridtype == 2
			max_order = config.probability*228
			mul_order = config.mulbability
		elsif config.gridtype == 3
			max_small = config.probability*228
			mul_small = config.mulbability
		elsif config.gridtype == 4
			max_big = config.probability*228
			mul_big = config.mulbability
		elsif config.gridtype == 5
			max_color = config.probability*228
			mul_color = config.mulbability
		end
	end

	objects = []
	objindex = 0
	for i in 0..227
		begin
			object, samenum, ordernum, smallnum, bignum, colornum = randomGrid
			if day_same + samenum <= max_same and day_order + ordernum <= max_order and
				day_small + smallnum <= max_small and day_big + bignum <= max_big and
				day_color + colornum <= max_color
				break
			end
			
		end while true

		day_same += samenum
		day_order += ordernum
		day_small += smallnum
		day_big += bignum
		day_color += colornum

		objects[i] = object
	end

	for i in 0..227
		index = rand(227)
		tmp = objects[index]
		objects[index] = objects[i]
		objects[i] = tmp
	end

	for i in 0..227
		Rails.logger.debug objects[i]
	end
	Rails.logger.debug day_same
	Rails.logger.debug day_order
	Rails.logger.debug day_small
	Rails.logger.debug day_big
	Rails.logger.debug day_color

	first_run = true

	task = Rufus::Scheduler.new
	task.cron '*/5 * * * *', :first_at => Time.now + 1, :last_at => Time.now + 19 * 3600 do

		first_run = false
		if !first_run
			grid = Grid.new
			grid.x1 = objects[objindex][0]
			grid.x2 = objects[objindex][1]
			grid.x3 = objects[objindex][2]
			grid.y1 = objects[objindex][3]
			grid.y2 = objects[objindex][4]
			grid.y3 = objects[objindex][5]
			grid.z1 = objects[objindex][6]
			grid.z2 = objects[objindex][7]
			grid.z3 = objects[objindex][8]

			curtime = Time.new
			grid.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
			grid.save	

			objindex += 1
			lssame, lsorder, lssmall, lsbig, lscolor = checkGrid(objects[objindex])

			for i in 0..9
				tracelog = Tracelog.new
				tracelog.gameid = grid.id
				tracelog.gametype = rand(5)+1
				tracelog.pos = rand(6)+1
				tracelog.coin = rand(100)+1
				tracelog.status = 0
				tracelog.userid = 2
				tracelog.useraccount = "test"
				tracelog.mulbability = 1.0
				tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
				tracelog.save
			end

			totalmoney = 0
			prizemoney = 0
			Tracelog.where("gameid = ?", grid.id).each do |log|
				totalmoney += log.coin
	  			if log.gametype = 1 and lssame.include?(log.pos)
	  				prizemoney += log.coin * mul_same
	  				log.update(status: 1)
	  			elsif log.gametype = 2 and lsorder.include?(log.pos)
	  				prizemoney += log.coin * mul_order
	  				log.update(status: 1)
	  			elsif log.gametype = 3 and lssmall.include?(log.pos)
	  				prizemoney += log.coin
	  				log.update(status: 1) * mul_small
	  			elsif log.gametype = 4 and lsbig.include?(log.pos)
	  				prizemoney += log.coin
	  				log.update(status: 1) * mul_big
	  			elsif log.gametype = 5 and lscolor.include?(log.pos)
	  				prizemoney += log.coin * mul_color
	  				log.update(status: 1)
	  			else
	  				log.update(status: -1)
	  			end
			end

			tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
			if tasklog == nil
				tasklog = Tasklog.new
				tasklog.totalbar = 228
				tasklog.currentbar = objindex+1
				tasklog.errorbar = 0
				tasklog.totalmoney = totalmoney
				tasklog.prizemoney = prizemoney
				tasklog.taskdate = curtime.strftime("%Y-%m-%d")
				tasklog.runtime = curtime.strftime("%Y-%m-%d %H:%M:%S")
				tasklog.save
			else
				tasklog.update(currentbar: objindex+1, totalmoney: totalmoney, prizemoney: prizemoney, runtime: curtime.strftime("%Y-%m-%d %H:%M:%S"))
			end
		else
			first_run = false
		end
	end
end