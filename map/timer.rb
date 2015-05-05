class Timer
  attr :now_time, :rap, :time_rap, :count, :last_time
  def initialize()
    @start_time = Time.now
		@minute = 0
		@second = 0
    @now_time = Time.now
   	@font = Font.new(32)
  end

  def plus
    @now_time = Time.now
    diff_time = (@now_time - @start_time).to_i
		@minute = diff_time / 60
    @second = diff_time % 60
    Window.drawFont(1050, 50, "#{@minute}分#{@second}秒", @font)
  end
end
