
class Enemy < Sprite
  CHAR_SIZE = 16
  SPEED = 2
  attr_accessor :move_x

  def initialize(x, y, image)
    super(x, y, image)
    @move_x = -1 * SPEED
  end

  def self.create
    Enemy.new(640.0, 240.0, Image.new(CHAR_SIZE, CHAR_SIZE, [0, 0, 255]))
  end

  def update(map)
    hit_left, move_x, move_y = map.check(self.x+CHAR_SIZE/2, self.y, @move_x, 0)
    hit_right, move_x, move_y = map.check(self.x-CHAR_SIZE/2, self.y, @move_x, 0)
    hitstate = hit_left + hit_right
    self.x += @move_x
    @move_x *= -1 if hitstate > 0
  end

  def draw
    Window.draw(self.x - CHAR_SIZE*0.5 - $camera_x, self.y - CHAR_SIZE*0.5 - $camera_y, self.image)
  end
end
