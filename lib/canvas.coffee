class window.Canvas extends Graphics
  GRID_STROKE: "lightgrey"
  COL_W: 10
  ROW_H: 10
  FPS: 25
  PAUSED: false 
  ENTITY_FILL: "green"

  initialize: ->
    @canvas = document.getElementById "myCanvas"
    @ctx = @canvas.getContext "2d"
    @width = @ctx.canvas.width
    @height = @ctx.canvas.height
    @initBoard()
    @initGrid()
    @initStats()
    @bindEvents?()

    setInterval(( => 
      unless @PAUSED
        @stats.begin()
        @render()
        @stats.end()
    ),(1000 / @FPS))

  render: ->
    @clearCanvas()
    @drawBoard()
    @drawGridData()
    @tick?()

  initStats: ->
    @stats = new Stats
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.right = '8px'
    @stats.domElement.style.top = '8px'
    document.body.appendChild @stats.domElement 

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

  set: ([col,row]) ->
    @drawGridItem(col,row)
    @grid[col][row] = 1

  get: (col,row)->
   return 0 if col < 0 || row < 0 || col >= @num_cols || row >= @num_rows

   @grid[col][row]

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

  drawGridItem: (col,row,f = @ENTITY_FILL) ->
    @drawSquare col * @COL_W,row * @ROW_H,@COL_W,@ROW_H,"",f