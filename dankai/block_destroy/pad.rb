
class Pad < Sprite
  def self.create
    pad_image = Image.new(100, 20)
    pad_image.boxFill(0, 0, 99, 19, [255, 255, 255])
    Pad.new(0, Window.height-pad_image.height*2, pad_image)
  end

  def update
    self.x = Input.mousePosX - self.image.width / 2
    self.x = 0 if x < 0
    self.x = Window.width-self.image.width   if x > Window.width-self.image.width
  end
end

