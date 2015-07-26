class JsondataController < ApplicationController

	def index
		curtime = Time.new
		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		if tasklog and tasklog.nexttime > curtime

			seconds = tasklog.nexttime - curtime - 8 * 3600
			if seconds >= 30
				seconds -= 30
			end
			grid = Grid.last

			render :json => {
							:seconds => seconds.to_i,
							:nextnum => tasklog.nextgameid,
							:curnum => grid.gameid,
							:curlog => grid.x1.to_s+","+grid.x2.to_s+","+grid.x3.to_s+","+
									grid.y1.to_s+","+grid.y2.to_s+","+grid.y3.to_s+","+
									grid.z1.to_s+","+grid.z2.to_s+","+grid.z3.to_s,
                        }
		else
			grid = Grid.last

			render :json => {
							:seconds => 400,
							:nextnum => tasklog.nextgameid,
							:curnum => grid.gameid,
							:curlog => grid.x1.to_s+","+grid.x2.to_s+","+grid.x3.to_s+","+
									grid.y1.to_s+","+grid.y2.to_s+","+grid.y3.to_s+","+
									grid.z1.to_s+","+grid.z2.to_s+","+grid.z3.to_s,
                        }
		end
	end
end
