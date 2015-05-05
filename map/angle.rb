class Angle
	def initialize(x, y)
		@x = x
		@y = y
		@image = Image.load("map/images/arrow.png")
		@my_angle = 0
	end
	def add(num) #	numは自分の角度を入れる
		@my_angle = num
	end
	def output(angle)
		@my_angle = angle
		Window.drawRot(@x,@y,@image,@my_angle)
	end
end
