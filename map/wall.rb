class Wall
	def initialize()
		@wall_status = 0
		@wall_img = []
		@wall_img.push(Image.load("map/images/block_nil.png"))
		@wall_img.push(Image.load("map/images/block_1.png"))
		@wall_img.push(Image.load("map/images/block_2.png"))
		@wall_img.push(Image.load("map/images/block_3.png"))
		@font = Font.new(32)
		@cm = 5.to_i #距離をto_iで整数化
	end
	def distance_font(distance)
		#@cm = 15.to_i ここで荷物との距離を入れる
		@cm = distance
		Window.drawFont(1050,500,"残り#{distance}cm",@font)
	end
	def output
		case @cm
			when 3...15
				@wall_status = 1
			when 15...30
				@wall_status = 2
			when 30...80
				@wall_status = 3
			else
				@wall_status = 0
		end
		Window.draw(980,150,@wall_img[@wall_status])
	end
end
