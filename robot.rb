#!/usr/bin/env ruby

class Robot
  COURSE = ['NORTH', 'EAST', 'SOUTH', 'WEST'].freeze

  def initialize(options = {space_width: 5, space_height: 6})
    @width = options[:space_width]
    @height = options[:space_height]
    @position = {}    
    @course_index = 0
    @init = false
  end
  
  def exec(input_str)
    return if input_str.nil?
    input_str.chomp!
    return if input_str == ""
    params = input_str.split(' ')
    if placed?
      case params[0]
        when "LEFT" then left
        when "RIGHT" then right
        when "MOVE" then move
        when "REPORT" then report
        when "PLACE"
          data = params[1].split(',')
          place(data[0], data[1], data[2])
        else
          puts "You enter wrong command. Try again"
      end
    else
      if params[0]=="PLACE"
        data = params[1].split(',')
        place(data[0], data[1], data[2])
      else
        puts "First command must be 'PLACE'"
      end
    end
  end

  #---------------------------------------PROTECTED METHODS--------------------------------------------#

  protected

  def left
    @course_index = @course_index == 0 ? COURSE.size-1 : @course_index-1
  end
  
  def right
    @course_index = @course_index == COURSE.size-1 ? 0 : @course_index+1
  end
  
  def move
    case COURSE[@course_index]
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
    p "Current position [#{@position[:x]}, #{@position[:y]}]. Course #{COURSE[@course_index]}"
  end
  
  def place(init_pos_x, init_pos_y, init_course)
    begin
      x = Integer(init_pos_x)
      y = Integer(init_pos_y)
      raise Error if incorrect_coordinates?(x,y)
      raise Error unless correct_course?(init_course)
      @course_index = COURSE.index(init_course)
      @position[:x] = x
      @position[:y] = y
      @init = true
      true
    rescue
      puts "You enter wrong command. Try again"
      false
    end
  end

  #---------------------------------------PRIVATE METHODS----------------------------------------#

  private

  def placed?
    @init
  end

  def incorrect_coordinates?(x, y)
    x>=@width || y>=@height || x<0 || y<0
  end

  def correct_course?(course)
    COURSE.include?(course)
  end

end

