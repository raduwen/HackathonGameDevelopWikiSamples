
require 'dxruby'

# 1s = 1frame にしました

FPS = 60
G = 0.1 # 100m/(s^2) 画面縦を1pixel=1kmにするとひどいことになるのでGを上げました

speed_max = 29 # 29km/s

angle = 80
speed = 9

bullet = Image.new(32, 32, [0,0,0,0])
bullet.circleFill(16, 16, 16, [255,0,0])
bx = 0
by = Window.height-bullet.height
vx = 0
vy = 0

font = Font.new(16)

Window.loop do
  if Input.keyDown?(K_UP)
    angle += 0.5
    angle = 90 if angle > 90
  end
  if Input.keyDown?(K_DOWN)
    angle -= 0.5
    angle = 0 if angle < 0
  end
  if Input.keyDown?(K_LEFT)
    speed -= 0.5
    speed = 0.5 if speed <= 0
  end
  if Input.keyDown?(K_RIGHT)
    speed += 0.5
    speed = 29 if speed > 29
  end

  if Input.keyPush?(K_Z)
    vx = Math.cos(angle/180.0*Math::PI)*speed
    vy = -1*Math.sin(angle/180.0*Math::PI)*speed
    bx = 0
    by = Window.height-bullet.height
  end

  bx += vx
  by += vy

  if bx > Window.width or by > Window.height
    vx = 0
    vy = 0
    bx = 0
    by = Window.height-bullet.height
  end
  vy += G

  Window.drawFont(0, 0, "angle: #{angle}", font)
  Window.drawFont(0, 20, "speed: #{speed}", font)
  Window.draw(bx, by, bullet)
end

