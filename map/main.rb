require 'dxruby'
require_relative 'map'

Window.width = 1300
Window.height = 800

map = Map.new

Window.loop do 

  map.mapping

  break if Input.key_push?(K_ESCAPE)

end
