# coding: utf-8

# 15パズル

require 'dxruby'

filename = Window.openFilename([["全てのファイル(*.*)", "*.*"]], "パズル画像を選択")
image = Image.loadToArray(filename, 4, 4)

width = image.first.width
height = image.first.height

if width < 32
  Window.scale = 48.0 / width
elsif width > 128
  Window.scale = (1.0 / width) * 128
end
Window.width = width * 4
Window.height = height * 4
Window.caption = "15Puzzle"

piece = (0..15).to_a

def click(x, y, piece)
  i = piece.index(15)
  if (((i % 4) - x).abs == 1 and (i / 4) == y) or (((i / 4) - y).abs == 1 and (i % 4) == x)
    piece[x + y * 4], piece[i] = piece[i], piece[x + y * 4]
    # tmp = piece[x + y * 4]
    # piece[x + y * 4] = piece[i]
    # piece[i] = tmp
  end
end

font = Font.new(128)
start = false

Window.loop do
  if Input.mousePush?(M_RBUTTON)
    1000.times do
      click(rand(4), rand(4), piece)
    end
    start = true
  end

  if Input.mousePush?(M_LBUTTON)
    click((Input.mousePosX / Window.scale / width).to_i, (Input.mousePosY / Window.scale / height).to_i, piece)
  end

  16.times do |i|
    if piece[i] != 15 or piece == (0..15).to_a
      Window.draw(i % 4 * width, i / 4 * height, image[piece[i]])
    end
  end

  if start and piece == (0..15).to_a
    w = font.getWidth("Clear")
    Window.drawFontEx((Window.width-w)/2, (Window.height-font.size)/2, "Clear", font, shadow: true)
  end
end

