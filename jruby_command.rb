#!/usr/local/bin/jruby
# coding: utf-8

require "./jruby_mainPanel.rb"

include Java

import java.lang.System

class Command
  def self.input
    loop do
      print "Life Game$ "
      command = gets.to_s
      analyze(command)
    end
  end

  def self.analyze(command)
    # puts "input done"
    if command == "random"
      # MainPanel.new.generate_random_cell
      print "generate cell"
    end
  end
end
