class JsondataController < ApplicationController

	def index
		curtime = Time.new
		tasklog = Tasklog.find_by_taskdate(curtime.strftime("%Y-%m-%d"))
		if tasklog and tasklog.nexttime > curtime

			seconds = tasklog.nexttime - curtime - 8 * 3600
			grid = Grid.last

			flash = {"1"=>1,"9"=>2,"10"=>3,"11"=>4,"12"=>5,"13"=>6,"14"=>7,"22"=>8,"23"=>9,"24"=>10,"25"=>11,"26"=>12,
				"27"=>13,"35"=>14,"36"=>15,"37"=>16,"38"=>17,"39"=>18,"40"=>19,"48"=>20,"49"=>21,"50"=>22,"51"=>23,"52"=>24}

			render :json => {
							:seconds => seconds.to_i,
							:nextnum => tasklog.nextgameid,
							:curnum => grid.gameid,
							:curlog => flash[grid.x1.to_s].to_s+","+flash[grid.x2.to_s].to_s+","+flash[grid.x3.to_s].to_s+","+
									flash[grid.y1.to_s].to_s+","+flash[grid.y2.to_s].to_s+","+flash[grid.y3.to_s].to_s+","+
									flash[grid.z1.to_s].to_s+","+flash[grid.z2.to_s].to_s+","+flash[grid.z3.to_s].to_s,
                        }
		else
			grid = Grid.last
			render :json => {
							:seconds => 400,
							:nextnum => "000000000",
							:curnum => "000000000",
							:curlog => "1,1,1,1,1,1,1,1,1",
                        }
		end
	end
end
