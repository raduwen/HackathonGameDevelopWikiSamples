
require 'dxruby'

speed = 5

player = Sprite.new(
  (Window.width-64)/2,
  (Window.height-64),
  Image.new(64, 64, [255, 0, 0])
)

enemy = Sprite.new(
  rand(Window.width),
  -1*64,
  Image.new(64, 64, [255, 255, 0])
)

Window.loop do
  player.x -= speed if Input.padDown?(P_LEFT)
  player.x += speed if Input.padDown?(P_RIGHT)
  player.y -= speed if Input.padDown?(P_UP)
  player.y += speed if Input.padDown?(P_DOWN)

  enemy.y += speed
  if enemy.y > Window.height
    enemy.y = -1*enemy.image.height
    enemy.x = rand(Window.width)
  end

  exit if player === enemy

  Sprite.draw([player, enemy])
end

