require 'rubygems'
require 'rufus-scheduler'
# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.new

objects = Array.new(228)
objindex = 0

def randomGrid
	object = Array[rand(52),rand(52),rand(52),
					rand(52),rand(52),rand(52),
					rand(52),rand(52),rand(52)]

	same = 0
	order = 0
	small = 0
	big = 0
	color = 0

	#all same
	for i in 0..2
		if object[i*3] == object[i*3+1] and object[i*3+1] == object[i*3+2]
			same += 1
		end
		if object[i] == object[i+3] and object[i+3] == object[i+6]
			same += 1
		end
	end

	#all order
	for i in 0..2
		if object[i*3]%13 <= 10 and object[i*3]+1 == object[i*3+1] and object[i*3+1]+1 == object[i*3+2]
			order += 1
		end
		if object[i]%13 <= 10 and object[i+3]+1 == object[i+3] and object[i+6]+1 == object[i+6]
			order += 1
		end
	end

	#all small
	for i in 0..2
		if object[i*3]%13 < 7 and object[i*3+1]%13 < 7 and object[i*3+2]%13 < 7
			small += 1
		end
		if object[i]%13 < 7 and object[i+3]%13 < 7 and object[i+6]%13 < 7
			small += 1
		end
	end

	#all big
	for i in 0..2
		if object[i*3]%13 > 7 and object[i*3+1]%13 > 7 and object[i*3+2]%13 > 7
			big += 1
		end
		if object[i]%13 > 7 and object[i+3]%13 > 7 and object[i+6]%13 > 7
			big += 1
		end
	end

	#same color
	for i in 0..2
		if object[i*3] <= 13 and object[i*3+1] <= 13 and object[i*3+2] <= 13
			color += 1
		end
		if object[i] <= 13 and object[i+3] <=13 and object[i+6] <= 13
			color += 1
		end

		if object[i*3] > 13 and object[i*3] <= 26 and object[i*3+1] > 13 and object[i*3+1] <= 26 and object[i*3+2] > 13 and object[i*3+2] <= 26
			color += 1
		end
		if object[i] > 13 and object[i] <= 26 and object[i+3] > 13 and object[i+3] <= 26 and object[i+6] > 13 and object[i+6] <= 26
			color += 1
		end
		
		if object[i*3] > 26 and object[i*3+1] > 26 and object[i*3+2] > 26
			color += 1
		end
		if object[i]+1 > 26 and object[i+3] > 26 and object[i+6] > 26
			color += 1
		end
	end

	return object,same,order,small,big,color 
end

def checkGrid (object)

	lssame = []
	lsorder = []
	lssmall = []
	lsbig = []
	lscolor = []

	#all same
	for i in 0..2
		if object[i*3] == object[i*3+1] and object[i*3+1] == object[i*3+2]
			lssame[lssame.length] = i+1
		end
		if object[i] == object[i+3] and object[i+3] == object[i+6]
			lssame[lssame.length] = i+4
		end
	end

	#all order
	for i in 0..2
		if object[i*3]%13 <= 10 and object[i*3]+1 == object[i*3+1] and object[i*3+1]+1 == object[i*3+2]
			lsorder[lsorder.length] = i+1
		end
		if object[i]%13 <= 10 and object[i+3]+1 == object[i+3] and object[i+6]+1 == object[i+6]
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
		if object[i*3]%13 > 7 and object[i*3+1]%13 > 7 and object[i*3+2]%13 > 7
			lsbig[lsbig.length] = i+1
		end
		if object[i]%13 > 7 and object[i+3]%13 > 7 and object[i+6]%13 > 7
			lsbig[lsbig.length] = i+4
		end
	end

	#same color
	for i in 0..2
		if object[i*3] <= 13 and object[i*3+1] <= 13 and object[i*3+2] <= 13
			lscolor[lscolor.length] = i+1
		end
		if object[i] <= 13 and object[i+3] <=13 and object[i+6] <= 13
			lscolor[lscolor.length] = i+4
		end

		if object[i*3] > 13 and object[i*3] <= 26 and object[i*3+1] > 13 and object[i*3+1] <= 26 and object[i*3+2] > 13 and object[i*3+2] <= 26
			lscolor[lscolor.length] = i+1
		end
		if object[i] > 13 and object[i] <= 26 and object[i+3] > 13 and object[i+3] <= 26 and object[i+6] > 13 and object[i+6] <= 26
			lscolor[lscolor.length] = i+4
		end
		
		if object[i*3] > 26 and object[i*3+1] > 26 and object[i*3+2] > 26
			lscolor[lscolor.length] = i+1
		end
		if object[i]+1 > 26 and object[i+3] > 26 and object[i+6] > 26
			lscolor[lscolor.length] = i+4
		end
	end

	return lssame,lsorder,lssmall,lsbig,lscolor
end

s.cron '01 05 * * *', :first_at => Time.now + 1, :timeout => '30m' do

	objects = []
	objindex = 0
	for i in 0..227
		objects[i] = randomGrid
	end

	for i in 0..227
		index = rand(226)
		tmp = objects[index]
		objects[index] = objects[i]
		objects[i] = tmp
	end

	task = Rufus::Scheduler.new
	task.cron '*/2 * * * *', :first_at => Time.now + 1, :last_at => Time.now + 19 * 3600 do
		
		grid = Grid.new
		grid.x1 = objects[objindex][0][0]
		grid.x2 = objects[objindex][0][1]
		grid.x3 = objects[objindex][0][2]
		grid.y1 = objects[objindex][0][3]
		grid.y2 = objects[objindex][0][4]
		grid.y3 = objects[objindex][0][5]
		grid.z1 = objects[objindex][0][6]
		grid.z2 = objects[objindex][0][7]
		grid.z3 = objects[objindex][0][8]

		curtime = Time.new
		grid.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
		grid.save	

		objindex += 1
		lssame, lsorder, lssmall, lsbig, lscolor = checkGrid(objects[objindex][0])

		for i in 0..9
			tracelog = Tracelog.new
			tracelog.gameid = grid.id
			tracelog.gametype = rand(5)
			tracelog.pos = rand(6)
			tracelog.coin = rand(100)
			tracelog.status = 0
			tracelog.userid = 2
			tracelog.time = curtime.strftime("%Y-%m-%d %H:%M:%S")
			tracelog.save
		end

		Tracelog.where("gameid = ?", grid.id).each do |log|
  			if log.gametype = 1 and lssame.include?(log.pos)
  				log.update(status: 1)
  			elsif log.gametype = 2 and lsorder.include?(log.pos)
  				log.update(status: 1)
  			elsif log.gametype = 3 and lssmall.include?(log.pos)
  				log.update(status: 1)
  			elsif log.gametype = 4 and lsbig.include?(log.pos)
  				log.update(status: 1)
  			elsif log.gametype = 5 and lscolor.include?(log.pos)
  				log.update(status: 1)
  			else
  				log.update(status: -1)
  			end
		end
	end
end