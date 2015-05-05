require_relative 'timer'
require_relative 'wall'
require_relative 'angle'

class Map

  def initialize()
    @bg_ary = Array.new(80).map{Array.new(120,0)}
		@move_count = 0
    @bg_img = []
    @bg_img.push(Image.load("map/images/gray.png"))
    @bg_img.push(Image.load("map/images/black.png"))
    @bg_img.push(Image.load("map/images/blue.png"))
    @bg_img.push(Image.load("map/images/green.png"))
    @bg_img.push(Image.load("map/images/yellow.png"))
    @bg_img.push(Image.load("map/images/red.png"))
    @bg_img.push(Image.load("map/images/white.png"))
    @bg_img.push(Image.load("map/images/brown.png"))
    @time = Timer.new
		@wall = Wall.new
		@angle = Angle.new(30,650)
		@sound_1 = Sound.new("map/sounds/ruby.wav")
		@senser_flg = true
		@font = Font.new(32)
  end

  def mapping(distance,color_code,angle)

    @time.plus

		my_y = @move_count / 120
    my_x = @move_count % 120

    120.times do |x|
      80.times do |y|
        ary_num = (@bg_ary[y][x]).to_i
        bg_col = @bg_img[ary_num]
        Window.draw(x * 8, y * 8, bg_col)
      end
    end
		@angle.output(angle)

	if Input.key_down?(K_LEFT) or Input.key_down?(K_RIGHT) or Input.key_down?(K_UP) or Input.key_down?(K_DOWN)
		@move_count += 1
		@angle.add(-10) #引数に自分の角度を入れる
	  case color_code#カラーコード
 	    when 1
 	      @bg_ary[my_y][my_x] = 1
 	    when 2
 	      @bg_ary[my_y][my_x] = 2
  	   when 3
 	      @bg_ary[my_y][my_x] = 3
 	    when 4
 	      @bg_ary[my_y][my_x] = 4
 	    when 5
 	      @bg_ary[my_y][my_x] = 5
 	    when 6
 	      @bg_ary[my_y][my_x] = 6
 	    when 7
 	      @bg_ary[my_y][my_x] = 7
  	end
	end

	if Input.key_down?(K_A) #アームどかす
		@sound_1.play
#		@senser_flg = true
	end

#	if Input.key_down?(K_S) #アーム戻す
#		@senser_flg = false
#	end

#	if @senser_flg == true #trueで荷物との距離を画像で表示する
		@wall.output
#	end

	@wall.distance_font(distance)

  end

end