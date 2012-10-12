
require 'dxruby'

Window.width = 640
Window.height = 480
CHIP_SIZE = 32
# MAP_WIDTH = Window.width / CHIP_SIZE
# MAP_HEIGHT = Window.height / CHIP_SIZE

G = 0.3
JUMP_POWER = 9.0
SPEED = 5.0
CHAR_SIZE = 30

$debug_font = Font.new(14)

MapData = [
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 1,1,0,0,0, 0,0,0,0,1],

  [1,0,0,0,0, 1,1,0,1,1, 0,0,0,0,0, 0,0,0,1,1, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,1,1,0, 0,0,0,0,0, 0,0,1,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,1,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,0,0,0,0, 0,0,1,1,0, 0,0,0,0,0, 0,0,1,1,0, 1,0,0,0,1],

  [1,0,0,0,0, 1,1,1,1,1, 0,0,0,0,1, 1,1,1,1,1, 1,0,0,0,1],
  [1,0,0,0,0, 1,1,1,1,1, 0,0,0,1,1, 1,1,1,1,1, 1,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,1,1, 0,0,0,0,0, 1,0,0,0,1],
  [1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,1],
  [1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1],
]

MAP_WIDTH  = MapData.first.size
MAP_HEIGHT = MapData.size

$camera_x = 0
$camera_y = 0
$player = Image.new(CHAR_SIZE, CHAR_SIZE, [255, 0, 0])
$player_x = 320.0
$player_y = 240.0
$player_down_speed = 0.0
$player_jump_flag = false

$enemy = Image.new(CHAR_SIZE, CHAR_SIZE, [0, 0, 255])
$enemy_x = 640.0
$enemy_y = 240.0
$enemy_move_x = -1*SPEED/2

map_images = []
map_images << Image.new(CHIP_SIZE, CHIP_SIZE, [255,255,255])
map_images << Image.new(CHIP_SIZE, CHIP_SIZE, [64, 64, 64])

def getChipParam(x, y)
  x = x / CHIP_SIZE
  y = y / CHIP_SIZE

  return 0 if x >= MAP_WIDTH or y >= MAP_HEIGHT or x < 0 or y < 0
  return MapData[y][x]
end

def charMove(move_x, move_y, size)
  dummy = 0.0
  hsize = size * 0.5

  d, dummy, move_y = mapHitCheck($player_x - hsize, $player_y + hsize, dummy, move_y)
  $player_down_speed = 0.0 if d == 3

  d, dummy, move_y = mapHitCheck($player_x + hsize, $player_y + hsize, dummy, move_y)
  $player_down_speed = 0.0 if d == 3

  d, dummy, move_y = mapHitCheck($player_x - hsize, $player_y - hsize, dummy, move_y)
  $player_down_speed = 0 if d == 4

  d, dummy, move_y = mapHitCheck($player_x + hsize, $player_y - hsize, dummy, move_y)
  $player_down_speed = 0 if d == 4
  $player_y += move_y

  d, move_x, dummy = mapHitCheck($player_x - hsize, $player_y + hsize, move_x, dummy)
  d, move_x, dummy = mapHitCheck($player_x + hsize, $player_y + hsize, move_x, dummy)
  d, move_x, dummy = mapHitCheck($player_x - hsize, $player_y - hsize, move_x, dummy)
  d, move_x, dummy = mapHitCheck($player_x + hsize, $player_y - hsize, move_x, dummy)
  $player_x += move_x

  if getChipParam($player_x-size*0.5, $player_y+size*0.5+1) == 0 and
     getChipParam($player_x+size*0.5, $player_y+size*0.5+1) == 0
    $player_jump_flag = true
  else
    $player_jump_flag = false
  end

  if (2*Window.width / 3 < $player_x - $camera_x and MAP_WIDTH*CHIP_SIZE-Window.width > $camera_x) or
    (Window.width / 3 > $player_x - $camera_x and 0 < $camera_x)
    $camera_x += move_x
  end
end

def mapHitCheck(x, y, move_x, move_y)
  afx = x + move_x
  afy = y + move_y

  res = 0

  if getChipParam(afx, afy) == 1
    blx = (afx.to_i / CHIP_SIZE) * CHIP_SIZE.to_f
    brx = (afx.to_i / CHIP_SIZE + 1) * CHIP_SIZE.to_f

    bty = (afy.to_i / CHIP_SIZE) * CHIP_SIZE.to_f
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

Window.loop do
  exit if Input.keyDown? K_ESCAPE
  # Player Move
  move_x = 0.0
  move_y = 0.0
  move_x -= SPEED if Input.padDown? P_LEFT
  move_x += SPEED if Input.padDown? P_RIGHT
  if $player_jump_flag == false and Input.padPush? P_BUTTON0
    $player_down_speed = -1 * JUMP_POWER
    $player_jump_flag = true
  end
  $player_down_speed += G
  move_y = $player_down_speed
  charMove(move_x, move_y, CHAR_SIZE)

  # EnemyMove
  hitstate, = mapHitCheck($enemy_x+CHAR_SIZE/2, $enemy_y, $enemy_move_x, 0)
  hitstate_l, = mapHitCheck($enemy_x-CHAR_SIZE/2, $enemy_y, $enemy_move_x, 0)
  hitstate += hitstate_l
  $enemy_x += $enemy_move_x
  $enemy_move_x *= -1 if hitstate == 1 or hitstate == 2

  Window.drawTile(-1*$camera_x, -1*$camera_y, MapData, map_images, 0, 0, MAP_WIDTH, MAP_HEIGHT, -1)
  Window.draw($player_x - CHAR_SIZE*0.5 - $camera_x, $player_y - CHAR_SIZE*0.5 - $camera_y, $player)
  Window.draw($enemy_x - CHAR_SIZE*0.5 - $camera_x, $enemy_y - CHAR_SIZE*0.5 - $camera_y, $enemy)
  Window.drawFontEx(0, 0,
    "#{$camera_x.to_i}, #{$camera_y.to_i} : #{$player_x.to_i}, #{$player_y.to_i}", $debug_font,
    color: [255,255,255], edge: true, edge_color: [0,0,0], edge_width: 1, z: 100)
end
