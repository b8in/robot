#!/usr/bin/env ruby

class Game
  COURSE = ['NORTH', 'EAST', 'SOUTH', 'WEST']
  
  def initialize(options = {space_width: 5, space_height: 6})
    @width = options[:space_width]
    @height = options[:space_height]
    @position = {}    
    @course_index = 0
    @init = false
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
      x = Integer(init_pos_x)
      y = Integer(init_pos_y)
      raise Error if x>=@width || y>=@height || x<0 || y<0
      raise Error unless ['NORTH', 'WEST', 'SOUTH', 'EAST'].include?(init_course)
      @course_index = Game.course.index(init_course)   
      @position[:x] = x
      @position[:y] = y
      @init = true
      return true
    rescue
      puts "You enter wrong command. Try again"
      return false
    end
  end
  
  def exec(input_str)  
    input_str.chomp!
    return if input_str.nil? || input_str == ""  
    params = input_str.split(' ')
    if @init
      case params[0]
        when "LEFT" then self.left
        when "RIGHT" then self.right 
        when "MOVE" then self.move
        when "REPORT" then self.report 
        when "PLACE" 
          data = params[1].split(',')
          self.place(data[0], data[1], data[2])
        else 
          puts "You enter wrong command. Try again"
      end 
    else
      if params[0]=="PLACE" 
        data = params[1].split(',')
        self.place(data[0], data[1], data[2]) 
      else
        puts "First command must be 'PLACE'"
      end     
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




