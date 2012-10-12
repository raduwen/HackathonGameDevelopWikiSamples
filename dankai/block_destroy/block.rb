
class Block < Sprite
  BLOCK_WIDTH = 60
  BLOCK_HEIGHT = 20
  W = BLOCK_WIDTH
  H = BLOCK_HEIGHT
  MARGIN_TOP = 50
  MARGIN = 4
  @@block_images = [
    Image.new(W, H, [255, 0, 0]),
    Image.new(W, H, [255, 255, 0]),
    Image.new(W, H, [0, 255, 0]),
  ]

  @@block_images[0].line(  0,   0, W-1,   0, [255, 150, 150])
  @@block_images[0].line(  0,   0,   0, H-1, [255, 150, 150])
  @@block_images[0].line(  0, H-1, W-1, H-1, [120,   0,   0])
  @@block_images[0].line(W-1,   0, W-1, H-1, [120,   0,   0])

  @@block_images[1].line(  0,   0, W-1,   0, [255, 255, 150])
  @@block_images[1].line(  0,   0 ,  0, H-1, [255, 255, 150])
  @@block_images[1].line(  0, H-1, W-1, H-1, [150, 150,   0])
  @@block_images[1].line(W-1,   0, W-1, H-1, [150, 150,   0])

  @@block_images[2].line(  0,   0, W-1,   0, [150, 255, 150])
  @@block_images[2].line(  0,   0,   0, H-1, [150, 255, 150])
  @@block_images[2].line(  0, H-1, W-1, H-1, [  0, 150,   0])
  @@block_images[2].line(W-1,   0, W-1, H-1, [  0, 150,   0])

  def self.setup
    blocks = []
    10.times do |i|
      6.times do |j|
        blocks << Block.new(i*(W+MARGIN) + 2, j*(H+MARGIN)+MARGIN_TOP, @@block_images[j/2])
      end
    end
    blocks
  end
end

