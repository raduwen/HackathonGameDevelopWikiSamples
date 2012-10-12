
require 'dxruby'

TILE_SIZE = 8
TILE_X = Window.width / TILE_SIZE
TILE_Y = Window.height / TILE_SIZE
images = []
images << Image.new(TILE_SIZE, TILE_SIZE, [255,255,255])
images << Image.new(TILE_SIZE, TILE_SIZE, [0,0,0])

# Initialize
now_data = []
old_data = []
TILE_Y.times do |y|
  now_data << []
  old_data << []
  TILE_X.times do |x|
    now_data[y] << 0
    old_data[y] << 0
  end
end

now_data[1][1] = 1

def copy_data(src, dst)
  TILE_Y.times do |y|
    TILE_X.times do |x|
      dst[y][x] = src[y][x]
    end
  end
end

font = Font.new(12)

frame_counter = 0
duration = 15

Window.loop do
  copy_data(now_data, old_data)

  if !Input.keyDown?(K_SPACE)
    if frame_counter % duration == 0
      TILE_Y.times do |y|
        TILE_X.times do |x|
          data_counter = 0
          3.times do |i|
            3.times do |j|
              dx = x+j-1
              dy = y+i-1
              next if dx == x and dy == y or dx < 0 or dy < 0
              if old_data[dy] != nil and old_data[dy][dx] != nil
                data_counter += old_data[dy][dx]
              end
            end
          end
          # 誕生
          if old_data[y][x] == 0
            now_data[y][x] = 1 if data_counter == 3
            # 生存/死
          else
            case data_counter
            when 2, 3 # 生存
              now_data[y][x] = 1
            else # 死
              now_data[y][x] = 0
            end
          end
        end
      end
    end
  else
    mx = Input.mousePosX / TILE_SIZE
    my = Input.mousePosY / TILE_SIZE
    if mx >= 0 and mx < TILE_X and my >= 0 and my < TILE_Y
      if Input.mouseDown?(M_LBUTTON)
        now_data[my][mx] = 1
      end
      if Input.mouseDown?(M_RBUTTON)
        now_data[my][mx] = 0
      end
    end
  end

  duration -= 1 if Input.keyPush?(K_UP)
  duration += 1 if Input.keyPush?(K_DOWN)
  duration = 1 if duration <= 0

  Window.drawTile(0, 0, now_data, images, 0, 0, TILE_X, TILE_Y)
  Window.drawFont(0, 0, duration.to_s, font, {color: [0,0,0]})
  frame_counter += 1
end

