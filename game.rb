#!/usr/bin/env ruby

class Game
  COURSE = ['NORTH', 'EAST', 'SOUTH', 'WEST']
  def initialize(space_width, space_height)
    @width = space_width
    @height = space_height
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
  
  def self.main
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
    
    game = Game.new(width, height)

    correct = false
    puts "Enter your command."
    while !correct
      begin 
        puts "E.g.: PLACE 0 0 NORTH"
        input_str = gets.chomp!.upcase!
        raise Error if input_str.nil? || input_str == ""
        input_params = input_str.split(' ')     
        raise Error if !(input_params[0] =="PLACE" || input_params[0] =="P")
        correct = game.place(input_params[1],input_params[2],input_params[3])
      rescue
        puts "You enter wrong command. Try again"
        correct = false
      end
    end

    play = true
    while play
      input_str = gets.chomp!.upcase!
      redo if input_str.nil? || input_str == ""
      params = input_str.split(' ')
      case params[0]
        when 'L', "LEFT" then game.left
        when 'R', "RIGHT" then game.right 
        when 'M', "MOVE" then game.move
        when 'REP', "REPORT" then game.report 
        when 'P', "PLACE" then game.place(params[1], params[2], params[3])
        when 'Q', "QUIT" then play = false
        else 
          puts "You enter wrong command. Try again"
      end
    end
    puts "Game over"  
  end

end

Game.main

