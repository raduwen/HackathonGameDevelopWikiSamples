
class Bullet < Sprite
  BULLET_SIZE = 24
  W = BULLET_SIZE
  H = BULLET_SIZE
  def self.create
    bullet_image = Image.new(W, H)
    bullet_image.circleFill(12, 12, 11, [255, 255, 255])
    Bullet.new(0, 416, bullet_image)
  end

  def reset_position(pad)
    self.x = pad.x + 38
    self.y = pad.y - H
  end

  def ready(pad)
    if Input.mousePush?(M_LBUTTON)
      @dx = rand(2) * 16 - 8
      @dy = -8
      return :playing
    else
      reset_position(pad)
      return :ready
    end
  end

  def playing(pad, blocks)
    self.x += @dx
    self.y += @dy

    # bullet <-> blocks
    hit_blocks = self.check(blocks)
    if hit_blocks.size > 0
      @dy *= -1
      self.y += @dy
      hit_blocks.each do |block|
        block.vanish
      end
    end

    # bullet <-> pad
    if self === pad
      @dy *= -1
      self.y += @dy
    end

    # bullet <-> wall
    if self.x < 0
      self.x = 0
      @dx *= -1
    end
    if self.x+self.image.width > Window.width
      self.x = Window.width-self.image.width
      @dx *= -1
    end
    if self.y < 0
      self.y = 0
      @dy *= -1
    end
    if self.y+self.image.height > Window.height
      return :gameover
    end
    return :playing
  end
end

