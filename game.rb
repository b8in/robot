#!/usr/bin/env ruby

require './robot.rb'

_R2D2 = Robot.new({space_width: 8, space_height: 8})

puts "Enter your command."
puts "E.g.: PLACE 0,0,NORTH"
play = true
while play  
  input_str = gets
  str = input_str.chomp.upcase
  if ['Q', "QUIT"].include?(str)
    play = false 
  else
    _R2D2.exec(input_str)
  end
end
puts "Game over"  

