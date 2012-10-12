
require 'dxruby'

player = Sprite.new((Window.width-32)/2, Window.height-32, Image.new(32, 32, [255,0,0]))
bullets = []
enemies = []
speed = 5

def generate_enemy
  Sprite.new(rand(Window.width), -32, Image.new(32, 32, [255,255,0]))
end

def generate_bullet(x, y)
  Sprite.new(x, y, Image.new(2, 16, [128,255,0]))
end

count = 0
Window.loop do
  enemies << generate_enemy if count % 20 == 0
  enemies.each do |enemy|
    enemy.y += speed
  end

  player.x -= speed if Input.padDown?(P_LEFT)
  player.x += speed if Input.padDown?(P_RIGHT)
  player.y -= speed if Input.padDown?(P_UP)
  player.y += speed if Input.padDown?(P_DOWN)

  if bullets.size < 5 and Input.padPush?(P_BUTTON0)
    bullets << generate_bullet(player.x+player.image.width/2, player.y+16)
  end
  bullets.each do |bullet|
    bullet.y -= speed
  end

  exit if player === enemies

  bullets.each do |bullet|
    enemies.each do |enemy|
      if bullet === enemy
        enemy.vanish
        bullet.vanish
      end
    end
  end

  enemies.delete_if { |e| e.vanished? or e.y  > Window.height }
  bullets.delete_if { |b| b.vanished? or b.y < 0}

  Sprite.draw([enemies, bullets, player])
  count += 1
end

