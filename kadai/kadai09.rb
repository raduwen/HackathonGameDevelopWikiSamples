
require 'dxruby'

G = 0.1

ball = Image.new(32, 32, [0,0,0,0])
ball.circleFill(16,16,16,[255,0,0])
x = 0
y = 0
vx = 5
vy = 0

FLOOR = 0.8
WALL  = 1.0

Window.loop do

  vy += G

  x += vx
  y += vy

  if x < 0
    x = 0
    vx *= WALL * -1
  end

  if x > Window.width-ball.width
    x = Window.width-ball.width
    vx *= WALL * -1
  end

  if y < 0
    y = 0
    vy *= FLOOR * -1
  end

  if y > Window.height-ball.height
    y = Window.height-ball.height
    vy *= FLOOR * -1
  end

  Window.draw(x, y, ball)
end

