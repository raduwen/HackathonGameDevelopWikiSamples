
require 'dxruby'

box = Image.new(320, 240, [255, 0, 0])

Window.loop do
  Window.draw(0, 0, box)
end

