require 'dxruby'
require_relative '../ruby-ev3/lib/ev3'
require_relative 'map/map'

Window.width = 1300
Window.height = 800

map = Map.new

class Carrier
  LEFT_MOTOR = "D"
  RIGHT_MOTOR = "A"
  ARM_MOTOR = "B"
  DISTANCE_SENSOR = "4"
  PORT = "COM3"
  WHEEL_SPEED = 50
  ARM_SPEED = 50
  DEGREES_CLAW = 5000
  CLAW_POWER = 30

  attr_reader :distance,:brick

  def initialize
    @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
    @brick.connect
    @busy = false
    @grabbing = false
  end

  def run_forward(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(*wheel_motors)
      @brick.start(speed, *wheel_motors)
    end
  end

  def run_backward(speed=WHEEL_SPEED)
    operate do
      @brick.start(speed, *wheel_motors)
    end
  end

  def turn_right(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(RIGHT_MOTOR)
      @brick.start(speed, *wheel_motors)
    end
  end

  def turn_left(speed=WHEEL_SPEED)
    operate do
      @brick.reverse_polarity(LEFT_MOTOR)
      @brick.start(speed, *wheel_motors)
    end
  end

  def stop_arm(speed=ARM_SPEED)
    operate do
      @brick.start(20, "B")
    end
  end

  def grab(speed=ARM_SPEED)
    operate do
      @brick.reverse_polarity(ARM_MOTOR)
      @brick.start(ARM_SPEED, ARM_MOTOR)
    end
  end

  def stop
    @brick.stop(true, *all_motors)
    @brick.run_forward(*all_motors)
    @busy = false
  end

  def operate
    unless @busy
      @busy = true
      yield(@brick)
    end
  end

  def update
    @distance = @brick.get_sensor(DISTANCE_SENSOR, 0)
  end

  def run
    update
    run_forward if Input.keyDown?(K_UP)
    run_backward if Input.keyDown?(K_DOWN)
    turn_right if Input.keyDown?(K_LEFT)
    turn_left if Input.keyDown?(K_RIGHT)
    stop_arm if Input.keyDown?(K_S)
    grab if Input.keyDown?(K_A)
    stop if [K_UP, K_DOWN, K_LEFT, K_RIGHT, K_W].all?{|key| !Input.keyDown?(key) }
  end

  def close
    stop
    @brick.clear_all
    @brick.disconnect
  end

  def all_motors
    @all_motors ||= self.class.constants.grep(/_MOTOR\z/).map{|c| self.class.const_get(c) }
  end

  def wheel_motors
    [LEFT_MOTOR, RIGHT_MOTOR]
  end
end

begin
  puts "starting..."
  font = Font.new(32)
  carrier = Carrier.new
  puts "connected..."

  Window.loop do

    puts carrier.brick.get_sensor("2",0).to_i
    map.mapping(carrier.distance.to_i,carrier.brick.get_sensor("3",2).to_i,carrier.brick.get_sensor("2",0).to_i)

    break if Input.keyDown?(K_SPACE)
    carrier.run
#    Window.draw_font(100, 200, "#{carrier.distance.to_i}cm", font)
    arm_value = carrier.brick.get_count("B")

    if Input.keyPush?( K_A )
      carrier.brick.reverse_polarity("B")
      carrier.brick.start(10, "B")
    end
    if Input.keyPush?( K_S )
      carrier.brick.start(10, "B")
    #  carrier.brick.stop(false, "B")
    end
    ##いろせんさー
  end
rescue
  p $!
  $!.backtrace.each{|trace| puts trace}

ensure
  puts "closing..."
  carrier.close
  puts "finished..."
end
