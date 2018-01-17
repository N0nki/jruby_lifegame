#!/usr/local/bin/jruby
# coding: utf-8

require "./jruby_mainPanel.rb"
require "./jruby_command.rb"

include Java

import java.lang.System
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JButton
import java.awt.Color
import java.awt.Container
import java.awt.Dimension
import java.awt.Image
import java.awt.Graphics
import java.awt.event.ActionListener

class LifeGame < JFrame
  include ActionListener

  def initialize
    super"Life Game implemented by JRuby"
    self.init_UI
    @button_flag = false
    @loop_flag   = false
    Command.input
  end

  def init_UI
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    self.visible = true
    self.setSize(1150, 1000)
    self.setLayout(nil)

    @startButton = JButton.new("Start")
    @startButton.setBounds(1040, 120, 70, 20)
    self.getContentPane.add(@startButton)
    @startButton.addActionListener(self)

    @stepButton = JButton.new("Step")
    @stepButton.setBounds(1040, 220, 70, 20)
    self.getContentPane.add(@stepButton)
    @stepButton.addActionListener(self)

    @randomButton = JButton.new("Random")
    @randomButton.setBounds(1040, 320, 70, 20)
    self.getContentPane.add(@randomButton)
    @randomButton.addActionListener(self)

    @clearButton = JButton.new("Clear")
    @clearButton.setBounds(1040, 420, 70, 20)
    self.getContentPane.add(@clearButton)
    @clearButton.addActionListener(self)

    @mainPanel = MainPanel.new(400, 320)
    @mainPanel.setBounds(10, 10, 1000, 900)
    # mainPanel.background = Color::BLACK
    @mainPanel.setBackground(Color::BLACK)
    self.getContentPane.add(@mainPanel)
  end

  def run
    if !@button_flag
      @startButton.setText("Stop")
      @loop_flag = true
      thread = Thread.start{
        begin
          @mainPanel.step
          sleep(0.05)
        end while @loop_flag
        Thread.stop
      }
    else
      @startButton.setText("Start")
      @loop_flag = false
    end
  end

  # implement ActionListener
  def actionPerformed(e)
    if e.getSource == @startButton
      run
      @button_flag = !@button_flag
    elsif e.getSource == @stepButton
      @mainPanel.step
    elsif e.getSource == @randomButton
      @mainPanel.generate_random_cell
    elsif e.getSource == @clearButton
      @mainPanel.init_field
      @mainPanel.repaint
    end
  end
end

LifeGame.new
