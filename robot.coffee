class Robot
  COURSE : ->
    ['NORTH', 'EAST', 'SOUTH', 'WEST']

  constructor : (options = {'spaceWidth' : 5, 'spaceHeight' : 6}) ->
    @width = options['spaceWidth']
    @height = options['spaceHeight']
    @position = {}
    @courseIndex = 0
    @init = false

  isPlaced : ->
    @init

  areCorrectCoordinates : (x, y) ->
    x? and y? and 0<=x<@width and 0<=y<@height

  isCorrectCourse : (course) ->
    course in @COURSE()

  left : ->
    @courseIndex = if @courseIndex == 0 then @COURSE().length-1 else @courseIndex-1

  right : ->
    @courseIndex = if @courseIndex == @COURSE().length-1 then 0 else @courseIndex+1

  move : ->
    switch @COURSE()[@courseIndex]
      when "NORTH"
        @position['y'] += 1 if @position['y'] != @height-1
      when "SOUTH"
        @position['y'] -= 1 if @position['y'] != 0
      when "WEST"
        @position['x'] -= 1 if @position['x'] != 0
      when "EAST"
        @position['x'] += 1 if @position['x'] != @width-1

  report : ->
    console.log "Current position [#{@position['x']}, #{@position['y']}]. Course #{@COURSE()[@courseIndex]}"

  place : (initPosX, initPosY, initCourse) ->
    try
      x = parseInt(initPosX)
      y = parseInt(initPosY)
      throw Error unless @areCorrectCoordinates(x,y)
      throw Error unless @isCorrectCourse(initCourse)
      @courseIndex = @COURSE().indexOf(initCourse)
      @position['x'] = x
      @position['y'] = y
      @init = true
      true
    catch error
      console.log "You enter wrong command. Try again"
      false

  exec : (inputStr) ->
    return unless inputStr?
    return if inputStr.match(/\S/) is null
    params = inputStr.split(' ')
    if @isPlaced()
      switch params[0]
        when "LEFT" then @left()
        when "RIGHT" then @right()
        when "MOVE" then @move()
        when "REPORT" then @report()
        when "PLACE"
          data = params[1].split(',')
          @place(data[0], data[1], data[2])
        else
          console.log "You enter wrong command. Try again"
    else
      if params[0]=="PLACE"
        data = params[1].split(',')
        @place(data[0], data[1], data[2])
      else
        console.log("First command must be 'PLACE'")


r2d2 = new Robot()
commands = "PLACE 0,0,NORTH;MOVE;REPORT;PLACE 0,0,NORTH;LEFT;REPORT;PLACE 1,2,EAST;MOVE;MOVE;LEFT;MOVE;REPORT".split(';')
r2d2.exec(command) for command in commands
