
require 'dxruby'

sin_line = Image.new(Window.width, Window.height, [0,0,0])

(0..Window.width).each do |x|
  sin_line.line(x, Math.sin(x*0.01)*Window.height/2.5+Window.height/2,
                x+1, Math.sin((x+1)*0.01)*Window.height/2.5+Window.height/2,
                [255, 0, 0])
end

Window.loop do
  Window.draw(0, 0, sin_line)
end

