
require 'dxruby'

UNIT_SIZE = 32
player = Sprite.new((Window.width-UNIT_SIZE)/2, Window.height-UNIT_SIZE, Image.new(UNIT_SIZE, UNIT_SIZE, [255,0,0]))
bullets = []
speed = 5


enemies = []
ENEMY_X = 3
ENEMY_Y = 2
ENEMY_MARGIN = 8
enemy_direction = -1
ENEMY_Y.times do |y|
  ENEMY_X.times do |x|
    enemies << Sprite.new(
      x*UNIT_SIZE+(Window.width-UNIT_SIZE*ENEMY_X)/2+x*ENEMY_MARGIN,
      y*UNIT_SIZE+y*ENEMY_MARGIN+120,
      Image.new(UNIT_SIZE, UNIT_SIZE, [255,255,0]))
  end
end

def generate_bullet(x, y)
  Sprite.new(x, y, Image.new(2, 16, [128,255,0]))
end

font = Font.new(64)

count = 0
Window.loop do
  if enemies.size > 0
    if count % (1+5*(enemies.size/ENEMY_X*ENEMY_Y)).to_i == 0
      change_direction = false
      enemies.each do |enemy|
        enemy.x += speed*enemy_direction
        if enemy.x < 0 or enemy.x > Window.width-enemy.image.width
          change_direction = true
        end
      end
      if change_direction
        enemy_direction *= -1
        enemies.each do |enemy| enemy.y += enemy.image.height end
      end
    end

    player.x -= speed if Input.padDown?(P_LEFT)
    player.x += speed if Input.padDown?(P_RIGHT)

    if bullets.size < 5 and Input.padPush?(P_BUTTON0)
      bullets << generate_bullet(player.x+player.image.width/2, player.y+16)
    end
    bullets.each do |bullet|
      bullet.y -= speed
    end

    exit if player === enemies

    bullets.each do |bullet|
      enemies.each do |enemy|
        if !bullet.vanished? and bullet === enemy
          enemy.vanish
          bullet.vanish
        end
      end
    end

    enemies.delete_if { |e| e.vanished? or e.y  > Window.height }
    bullets.delete_if { |b| b.vanished? or b.y < 0}
    count += 1
  else
    str = "Clear!"
    width = font.getWidth(str)
    Window.drawFont((Window.width-width)/2, (Window.height-font.size)/2, str, font)
  end

  Sprite.draw([enemies, bullets, player])
end

