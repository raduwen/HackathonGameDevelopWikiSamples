# coding: utf-8

# ブロック崩し(Sprite版)
# 参考: dxurby/sample/classic_sample/block_destroy.rb

require 'dxruby'
require './block'
require './bullet'
require './pad'

Window.caption = "ブロック崩し"

blocks = Block.setup
bullet = Bullet.create
pad = Pad.create

state = :ready

font = Font.new(72)

Window.loop do
  pad.update

  case state
  when :ready
    state = bullet.ready(pad)
  when :playing
    state = bullet.playing(pad, blocks)
  when :clear, :gameover
    bullet.reset_position(pad)
    if Input.mousePush?(M_LBUTTON)
      state = :playing
      bullet.ready(pad)
      blocks = Block.setup
    end
  end

  Sprite.clean(blocks)

  if state != :gameover and state != :clear
    Sprite.draw([blocks, bullet, pad])
  else
    str = state.to_s
    width = font.getWidth(str)
    Window.drawFont(
      (Window.width-width)/2,
      (Window.height-font.size)/2,
      str, font
    )
  end
end

