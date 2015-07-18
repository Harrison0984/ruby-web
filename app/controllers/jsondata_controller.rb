class JsondataController < ApplicationController

	def index
		curtime = Time.new
		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		if tasklog
			seconds = tasklog.nexttime - curtime - 8 * 3600
			if seconds < 0
				seconds = 400
			end
			grids = Grid.last(3)
			time = curtime.strftime("%H:%M:%S")

			render :json => {
							:nexttime => tasklog.nexttime.strftime("%H:%M:%S"),
							:seconds => seconds.to_i+10,
							:nownum => curtime.strftime("%Y%m%d")+(tasklog.currentbar).to_s,
							:nowlog => grids[0].x1.to_s+","+grids[0].x2.to_s+","+grids[0].x3.to_s+","+
									grids[0].y1.to_s+","+grids[0].y2.to_s+","+grids[0].y3.to_s+","+
									grids[0].z1.to_s+","+grids[0].z2.to_s+","+grids[0].z3.to_s,
							:hisnum1 => curtime.strftime("%Y%m%d")+(tasklog.currentbar-1).to_s,
							:hislog1 => grids[1].x1.to_s+","+grids[1].x2.to_s+","+grids[1].x3.to_s+","+
									grids[1].y1.to_s+","+grids[1].y2.to_s+","+grids[1].y3.to_s+","+
									grids[1].z1.to_s+","+grids[1].z2.to_s+","+grids[1].z3.to_s,
							:hisnum2 => curtime.strftime("%Y%m%d")+(tasklog.currentbar-2).to_s,
 							:hislog2 => grids[2].x1.to_s+","+grids[2].x2.to_s+","+grids[2].x3.to_s+","+
									grids[2].y1.to_s+","+grids[2].y2.to_s+","+grids[2].y3.to_s+","+
									grids[2].z1.to_s+","+grids[2].z2.to_s+","+grids[2].z3.to_s,
							:nextNum => tasklog.nextgameid,
                        }
		end
	end
end
