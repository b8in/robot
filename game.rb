#!/usr/bin/env ruby

class Game
  COURSE = ['NORTH', 'EAST', 'SOUTH', 'WEST']
  def initialize(options = {space_width: 5, space_height: 6})
    @width = options[:space_width]
    @height = options[:space_height]
    @position = {}    
    @course_index = 0
  end
  
  def self.course
    COURSE
  end
  
  def left
    @course_index = @course_index == 0 ? COURSE.size-1 : @course_index-1
  end
  
  def right
    @course_index = @course_index == COURSE.size-1 ? 0 : @course_index+1
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
  
  def place(init_pos_x, init_pos_y, init_course)
    begin
      x = Integer(init_pos_x).abs
      y = Integer(init_pos_y).abs
      raise Error if x>=@width || y>=@height
      case init_course
        when 'N','n' then init_course = "NORTH"
        when 'W','w' then init_course = "WEST"
        when 'S','s' then init_course = "SOUTH"
        when 'E','e' then init_course = "EAST"
      end
      raise Error unless ['NORTH', 'WEST', 'SOUTH', 'EAST'].include?(init_course)
      @course_index = Game.course.index(init_course)   
      @position[:x] = x
      @position[:y] = y
      return true
    rescue
      puts "You enter wrong command. Try again"
      return false
    end
  end
  
  def exec(input_str)  
    input_str.chomp!
    return if input_str.nil? || input_str == ""
    str = input_str.upcase    
    params = str.split(' ')
    case params[0]
      when 'L', "LEFT" then self.left
      when 'R', "RIGHT" then self.right 
      when 'M', "MOVE" then self.move
      when 'REP', "REPORT" then self.report 
      when 'P', "PLACE" 
        data = params[1].split(',')
        self.place(data[0], data[1], data[2])
      else 
        puts "You enter wrong command. Try again"
    end  
  end

end

game = Game.new({space_width: 8, space_height: 8})

puts "Enter your command."
puts "E.g.: PLACE 0,0,NORTH"
play = true
while play  
  input_str = gets
  str = input_str.chomp!.upcase!
  if ['Q', "QUIT"].include?(str)
    play = false 
  else
    game.exec(input_str)
  end
end
puts "Game over"  




