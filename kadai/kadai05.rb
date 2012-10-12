
require 'dxruby'

box = Image.new(320, 240, [255, 0, 0])
x = 0
y = 0
speed = 5

Window.loop do
  if Input.padDown?(P_LEFT)
    x -= speed
  end

  if Input.padDown?(P_RIGHT)
    x += speed
  end

  if Input.padDown?(P_UP)
    y -= speed
  end

  if Input.padDown?(P_DOWN)
    y += speed
  end

  Window.draw(x, y, box)
end

