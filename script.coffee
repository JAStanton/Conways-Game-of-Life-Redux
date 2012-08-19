class Graphics
  STROKE: "#000"
  FILL: "#DDD"

  drawSquare: (x,y,w,h,s = @STROKE,f = @FILL) ->
    @ctx.beginPath()
    @ctx.rect x, y, w, h
    @ctx.fillStyle = f
    @ctx.fill()
    @ctx.lineWidth = 1
    @ctx.strokeStyle = s
    @ctx.stroke()

  drawLine: (x,y,x2,y2,s = @GRID_STROKE)->
    @ctx.strokeStyle = s
    @ctx.beginPath()
    @ctx.moveTo(x,y)
    @ctx.lineTo(x2,y2)
    @ctx.closePath()
    @ctx.stroke()

class Conway extends Graphics
  GRID_STROKE: "lightgrey"
  DUDE: "green"
  COL_W: 10
  ROW_H: 10
  FPS: 25

  initialize: ->
    @canvas = document.getElementById "myCanvas"
    @ctx = @canvas.getContext "2d"
    @width = @ctx.canvas.width
    @height = @ctx.canvas.height
    @initBoard()
    @initGrid()
    @bindEvents()
    @initStats()

    setInterval(( => 
      unless @mouse_state
        @stats.begin()
        @render()
        @stats.end()
    ),(1000 / @FPS))
  
  initStats: ->
    @stats = new Stats

    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.right = '8px'
    @stats.domElement.style.top = '8px'
    document.body.appendChild @stats.domElement 


  render: ->
    @clearCanvas()
    @drawBoard()
    @drawGridData()
    @tick()

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

  bindEvents: ->
    @canvas.onmousedown = (e) => @onMouseDown(e)
    @canvas.onmouseup   = (e) => @onMouseUp(e)
    @canvas.onmouseout  = (e) => @onMouseUp(e)
    @canvas.onmousemove = (e) => @onMouseMove(e)
  
  onMouseDown:(e) ->
    @mouse_state = 1
    @set(@getPos(e))

  onMouseUp:(e) -> @mouse_state = 0

  onMouseMove:(e) -> @set(@getPos(e)) if @mouse_state
  
  set: ([col,row]) ->
    @drawGridItem(col,row)
    @grid[col][row] = 1

  getPos: (e) ->
    position = @canvas.getBoundingClientRect()
    x = e.clientX - position.left
    y = e.clientY - position.top

    col = Math.floor(x / @COL_W)
    row = Math.floor(y / @ROW_H)

    [col,row]

  numNeighbors: (col,row)->
    up         = @getGridItem( col     , row - 1 )
    down       = @getGridItem( col     , row + 1 )
    left       = @getGridItem( col - 1 , row     )
    right      = @getGridItem( col + 1 , row     )
    up_right   = @getGridItem( col + 1 , row - 1 )
    down_right = @getGridItem( col + 1 , row + 1 )
    down_left  = @getGridItem( col - 1 , row + 1 )
    up_left    = @getGridItem( col - 1 , row - 1 )

    up + down + left + right + up_right + down_right + down_left + up_left
  
  getGridItem: (col,row)->
   return 0 if col < 0 || row < 0 || col >= @num_cols || row >= @num_rows

   @grid[col][row]

  initBoard: ->
    @max_width = @width - (@width % @COL_W)
    @max_height = @height - (@height % @ROW_H)
    @num_cols = @max_width / @COL_W
    @num_rows = @max_height / @ROW_H
  
  initGrid: ->
    @grid = []
    for x in [0...@num_cols]
      @grid[x] = []
      for y in [0...@num_rows]
        @grid[x][y] = Math.round(Math.random())

  clearCanvas: ->
    @ctx.clearRect 0,0,@width,@height

  drawBoard: ->
    @drawSquare 0,0,@max_width,@max_height
    @drawGrid()

  drawGrid: ->
    for x in [@COL_W...@max_width] by @COL_W
      @drawLine x,1,x,@max_height - 1

    for y in [@ROW_H...@max_height] by @ROW_H
      @drawLine 1,y,@max_width - 1,y

  drawGridData: ->
    for cols,col in @grid
      for value,row in cols
        @drawGridItem col,row if value == 1

  drawGridItem: (col,row,f = @DUDE) ->
    @drawSquare col * @COL_W,row * @ROW_H,@COL_W,@ROW_H,"",f

window.onload = ->
  conway = new Conway
  conway.initialize()
