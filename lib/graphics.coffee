class window.Graphics
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
