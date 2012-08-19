# Conways Game of Life
# Author: Jonathan Stanton
# Website: jastanton.com
# Date: Aug 19, 2012

class window.Conway extends Canvas
  
  tick: ->
    kill = []
    resurect = []

    for cols,col in @grid
      for value,row in cols
        num_neighbours = @numNeighbors(col,row)
        is_alive = if value then true else false

        kill.push [col,row] if is_alive && num_neighbours < 2 # upder-population
        kill.push [col,row] if is_alive && num_neighbours > 3 # overcrowding
        resurect.push [col,row] if !is_alive && num_neighbours == 3 # reproduction

    for cell in kill
      @grid[cell[0]][cell[1]] = 0
    
    for cell in resurect
      @grid[cell[0]][cell[1]] = 1

  numNeighbors: (col,row)->
    up         = @get( col     , row - 1 )
    down       = @get( col     , row + 1 )
    left       = @get( col - 1 , row     )
    right      = @get( col + 1 , row     )
    up_right   = @get( col + 1 , row - 1 )
    down_right = @get( col + 1 , row + 1 )
    down_left  = @get( col - 1 , row + 1 )
    up_left    = @get( col - 1 , row - 1 )

    up + down + left + right + up_right + down_right + down_left + up_left

  bindEvents: ->
    @canvas.onmousedown = (e) => @onMouseDown(e)
    @canvas.onmouseup   = (e) => @onMouseUp(e)
    @canvas.onmouseout  = (e) => @onMouseUp(e)
    @canvas.onmousemove = (e) => @onMouseMove(e)
  
  onMouseDown:(e) ->
    @mouse_state = 1
    @PAUSED = 1
    @set(@getMousePos(e))

  onMouseUp:(e) -> 
    @mouse_state = 0
    @PAUSED = 0

  onMouseMove:(e) -> @set(@getMousePos(e)) if @mouse_state
  
