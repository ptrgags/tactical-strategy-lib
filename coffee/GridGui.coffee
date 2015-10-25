class @GridGui
    constructor: (@grid, @cell_size = 32, @line_color = "grey", @outline_color = "black") ->
        @shape = new createjs.Shape
        @redraw()
    
    set_pos: (x, y) ->
        @shape.x = x
        @shape.y = y
    
    get_pos: ->
        [@shape.x, @shape.y]
    
    redraw: ->
        gfx = @shape.graphics
        gfx.setStrokeStyle 1
        for row in [0...@grid.rows]
            for col in [0...@grid.cols]
                gfx.beginStroke @line_color
                gfx.drawRect col * @cell_size, row * @cell_size, @cell_size, @cell_size
        gfx.setStrokeStyle 2
        gfx.beginStroke @outline_color
        gfx.drawRect 0, 0, @grid.cols * @cell_size, @grid.rows * @cell_size
        
    