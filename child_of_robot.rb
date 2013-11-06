#!/usr/bin/env ruby

require './robot'

class Rob < Robot

  def initialize(options = {space_width: 5, space_height: 6})
    super(options)
  end
  
  # теперь наследование от класса Rob вызовет RunTime Error т.о. невозможно создать потомков
  def self.inherited(klass)
    raise "No-No-No"
  end
  
  protected
  
  def right
    Robot.instance_method(:left).bind(self).call
  end
  
  def left
    Robot.instance_method(:right).bind(self).call
  end
  
  #def move
  #  p "MOVE"
  #end
  
  #private
  
  #def correct_course?(init_course)
  #  true
  #end
  
  #def placed?
  #  true
  #end

end

_R2D2 = Rob.new({space_width: 8, space_height: 8})

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
puts "Game over@@"  




