
class Player < Sprite
  attr_accessor :down_speed, :jump_flag
  JUMP_POWER = 9.0
  SPEED = 5.0
  CHAR_SIZE = 30

  def initialize(x, y, image)
    super(x, y, image)
    @down_speed = 0.0
    @jump_flag = false
  end

  def self.create
    image = Image.new(CHAR_SIZE, CHAR_SIZE, [255, 0, 0])
    Player.new(320.0, 240.0, image)
  end

  def update(map)
    move_x = 0.0
    move_y = 0.0
    move_x -= SPEED if Input.padDown? P_LEFT
    move_x += SPEED if Input.padDown? P_RIGHT
    if @jump_flag == false and Input.padPush? P_BUTTON0
      @down_speed = -1 * JUMP_POWER
      @jump_flag = true
    end
    @down_speed += G
    move_y = @down_speed
    move(map, move_x, move_y)
  end

  def move(map, move_x, move_y)
    dummy = 0.0
    w = self.image.width
    h = self.image.height
    w_half = w / 2
    h_half = h / 2

    direction, dummy, move_y = map.check(self.x - w_half, self.y + h_half, dummy, move_y)
    @down_speed = 0.0 if direction == 3

    direction, dummy, move_y = map.check(self.x + w_half, self.y + h_half, dummy, move_y)
    @down_speed = 0.0 if direction == 3

    direction, dummy, move_y = map.check(self.x - w_half, self.y - h_half, dummy, move_y)
    @down_speed = 0 if direction == 4

    direction, dummy, move_y = map.check(self.x + w_half, self.y - h_half, dummy, move_y)
    @down_speed = 0 if direction == 4
    self.y += move_y

    direction, move_x, dummy = map.check(self.x - w_half, self.y + h_half, move_x, dummy)
    direction, move_x, dummy = map.check(self.x + w_half, self.y + h_half, move_x, dummy)
    direction, move_x, dummy = map.check(self.x - w_half, self.y - h_half, move_x, dummy)
    direction, move_x, dummy = map.check(self.x + w_half, self.y - h_half, move_x, dummy)
    self.x += move_x

    if map.chip_param(self.x-w*0.5, self.y+h*0.5+1) == 0 and
       map.chip_param(self.x+w*0.5, self.y+h*0.5+1) == 0
      @jump_flag = true
    else
      @jump_flag = false
    end

    if (2 * Window.width / 3 < self.x - $camera_x and map.width*Map::CHIP_SIZE-Window.width > $camera_x) or
       (    Window.width / 3 > self.x - $camera_x and 0 < $camera_x)
      $camera_x += move_x
    end
  end

  def draw
    Window.draw(self.x - self.image.width * 0.5 - $camera_x,
                self.y - self.image.height * 0.5 - $camera_y,
                self.image)
  end
end

