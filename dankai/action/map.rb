
class Map
  CHIP_SIZE = 32

  def initialize(data)
    @data = data
    @images = []
    @images << Image.new(CHIP_SIZE, CHIP_SIZE, [255,255,255])
    @images << Image.new(CHIP_SIZE, CHIP_SIZE, [64, 64, 64])
  end

  def width
    @data.first.size
  end

  def height
    @data.size
  end

  def chip_param(x, y)
    x = x / CHIP_SIZE
    y = y / CHIP_SIZE

    return 0 if x >= self.width or y >= self.height or x < 0 or y < 0
    return @data[y][x]
  end

  def draw
    Window.drawTile(-1*$camera_x, -1*$camera_y, @data, @images, 0, 0, self.width, self.height, -1)
  end

  #=== マップとの当たり判定
  #
  #戻り値:: [当たった方向, fix_move_x, fix_move_y]
  #   0: あたってない
  #   1: 左辺
  #   2: 右辺
  #   3: 上辺
  #   4: 下辺
  def check(x, y, move_x, move_y)
    afx = x + move_x
    afy = y + move_y

    res = 0

    if chip_param(afx, afy) == 1
      blx = (afx.to_i / CHIP_SIZE)     * CHIP_SIZE.to_f
      brx = (afx.to_i / CHIP_SIZE + 1) * CHIP_SIZE.to_f
      bty = (afy.to_i / CHIP_SIZE)     * CHIP_SIZE.to_f
      bby = (afy.to_i / CHIP_SIZE + 1) * CHIP_SIZE.to_f

      if move_y > 0
        move_y = bty-y-1.0
        res = 3
        return res, move_x, move_y
      end
      if move_y < 0
        move_y = bby-y+1.0
        res = 4
        return res, move_x, move_y
      end
      if move_x > 0
        move_x = blx-x-1.0
        res = 1
        return res, move_x, move_y
      end
      if move_x < 0
        move_x = brx-x+1.0
        res = 2
        return res, move_x, move_y
      end
      res = 4
      return res, move_x, move_y
    end

    return 0, move_x, move_y
  end
end

