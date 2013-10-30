#!/usr/bin/env ruby

class Game
  def initialize(space_width, space_height, init_pos_x, init_pos_y, init_course)
    @width = space_width
    @height = space_height
    @position = { x: init_pos_x, y: init_pos_y }
    @@course = ['NORTH', 'EAST', 'SOUTH', 'WEST']
    @course_index = Game.course.index(init_course)
  end
  
  def self.course
    @@course
  end
  
  def left
    @course_index = @course_index == 0 ? @@course.size-1 : @course_index-1
  end
  
  def right
    @course_index = @course_index == @@course.size-1 ? 0 : @course_index+1
  end
  
  def move
    case Game.course[@course_index]
      when "NORTH"
        @position[:y] += 1 if @position[:y] != @height-1
      when "SOUTH"
        @position[:y] -= 1 if @position[:y] != 0
      when "WEST"
        @position[:x] -= 1 if @position[:x] != 0
      when "EAST"
        @position[:x] += 1 if @position[:x] != @width-1
    end
  end
  
  def report
    puts "Current position [#{@position[:x]}, #{@position[:y]}]. Course #{Game.course[@course_index]}"
  end

end

correct = false
width = 5
height = 6
while !correct
  puts "Enter space dimensions. Default:\n 5 6"
  input_str = gets.chomp!
  break if input_str.nil? || input_str == ''
  input_params = input_str.split(' ')
  begin 
    width = Integer(input_params[0]).abs
    height = Integer(input_params[1]).abs
    puts "OK: width = #{width}; height = #{height}"
    correct = true
  rescue
    puts "You enter wrong parameters (must be: count = 2, type = integer)"
    correct = false
  end
end

correct = false
puts "Enter your command."
while !correct
  begin 
    puts "E.g.: PLACE 0 0 NORTH"
    input_str = gets.chomp!
    input_params = input_str.split(' ')
    raise Error if input_params.size < 4
    x = Integer(input_params[1]).abs
    y = Integer(input_params[2]).abs
    raise Error if x>=width || y>=height
    raise Error if !(input_params[0].upcase =="PLACE" || input_params[0].upcase =="P")
    case input_params[3]
      when 'N','n' then input_params[3] = "NORTH"
      when 'W','w' then input_params[3] = "WEST"
      when 'S','s' then input_params[3] = "SOUTH"
      when 'E','e' then input_params[3] = "EAST"
    end
    raise Error unless ['NORTH', 'WEST', 'SOUTH', 'EAST'].include?(input_params[3].upcase) 
    init_course = input_params[3]
    correct = true
  rescue
    puts "You enter wrong command. Try again"
    correct = false
  end
end

game = Game.new(width, height, x, y, init_course)
game.report

play = true
while play
  input_str = gets.chomp!.upcase!
  case input_str
    when 'L', "LEFT" then game.left
    when 'R', "RIGHT" then game.right 
    when 'M', "MOVE" then game.move
    when 'REP', "REPORT" then game.report 
    when 'Q', "QUIT" then play = false
    else 
      puts "You enter wrong command. Try again"
  end
end
puts "Game over"
