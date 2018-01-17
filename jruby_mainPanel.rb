#!/usr/local/bin/jruby
# coding: utf-8

include Java

import java.lang.System
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JButton
import java.awt.Component
import java.awt.Color
import java.awt.Container
import java.awt.Dimension
import java.awt.Image
import java.awt.Graphics
import java.awt.event.ActionListener
import java.awt.event.MouseListener

DEAD  = 0
ALIVE = 1

class MainPanel < JPanel
  include MouseListener

  def initialize(width, height)
    # 明示的に継承元クラスの引数なしコンストラクタを呼び出す
    super()
    @width = width;
    @height = height;
    # @off_screen = Image.new
    # @offg = Graphics.new
    setPreferredSize(Dimension.new(@width * 5, @height * 5))
    # self.preferred_size = Dimension.new(@width * 5, @height * 5)
    self.addMouseListener(self)
    init_field
  end

  # フィールド初期化
  def init_field
    # @temp = Array.new(@width).map { Array.new(@height, DEAD) }
    # @field = @temp.to_java(:int)
    @field = Java::int[@width][@height].new
    for i in 0...@width
      for j in 0...@height
          @field[i][j] = DEAD
      end
    end
  end

  def get_cell(i, j)
    if i>=@width || j>=@height
      return;
    else
      return @field[i][j]
    end
  end

  # フィールドをクリックした時セルを生成
  def generate_cell_with_click(me)
    i = me.getX() / 5
    j = me.getY() / 5

    if i>=@width || j>=@height
      return;
    else
      if @field[i][j] == ALIVE
        @field[i][j] = DEAD
      else
        @field[i][j] = ALIVE
      end
      self.repaint
    end
  end

  # ランダムにセルを生成するメソッド
  def generate_random_cell
    init_field
    self.repaint
    for i in 0...@width
      for j in 0...@height
        if rand < 0.3
          @field[i][j] = ALIVE
        end
      end
    end
    self.repaint
  end

  def update(g)
    paint(g)
  end

  def paint(g)
    if @off_screen == nil
      @off_screen = createImage(@width * 5, @height * 5)
      @offg = @off_screen.getGraphics
    end
    @offg.color = Color::BLACK
    @offg.fillRect(0, 0, @width * 5, @height * 5)
    @offg.color = Color::GREEN
    for i in 0...@width
      for j in 0...@height
        if @field[i][j] == ALIVE
          @offg.fillRect(i * 5, j * 5, 4, 4)
        end
      end
    end
    g.clearRect(0, 0, getSize().width, getSize().height)
    g.drawImage(@off_screen, 0, 0, self)
  end

  # @field[i][j]の周囲8マスに存在するセルの数をカウントするメソッド
  def count_around_cell(i, j)
    if i==0 || i==@width-1 || j==0 || j==@height-1
      return 0
    end

    counter = 0
    counter = @field[i-1][j-1] +
              @field[i][j-1]   +
              @field[i+1][j-1] +
              @field[i-1][j]   +
              @field[i+1][j]   +
              @field[i-1][j+1] +
              @field[i][j+1]   +
              @field[i+1][j+1]
    return counter
  end

  # 世代を1つだけ進めるメソッド
  def step
    # next_field = Array.new(@width).map { Array.new(@height, DEAD) }
    next_field = Java::int[@width][@height].new

    for i in 0...@width
      for j in 0...@height
        case count_around_cell(i, j)
        when 2
          next_field[i][j] = @field[i][j]
        when 3
          next_field[i][j] = ALIVE
        else
          next_field[i][j] = DEAD
        end
      end
    end
    @field = next_field
    self.repaint
  end

  # implement MouseListener
  def mouseEntered(me)
  end

  def mouseExited(me)
  end

  def mousePressed(me)
    generate_cell_with_click(me)
    # System.out.println("mouse pressed")
  end

  def mouseClicked(me)
  end

  def mouseReleased(me)
  end
end
