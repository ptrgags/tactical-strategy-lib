class @Grid
    constructor: (@rows, @cols, @default = null) ->
        @grid = ((@default for row in [0...@rows]) for col in [0...@cols])
    
    put: (row, col, obj) ->
        @grid[row][col] = obj
    
    put_entity: (entity) ->
        @grid[entity.row][entity.col] = entity
    
    get: (row, col) ->
        @grid[row][col]
        
    remove: (row, col) ->
        val = @grid[row][col]
        @grid[row][col] = @default
        val
    
    is_valid: (row, col) ->
        0 <= row < @rows and 0 <= col < @cols
    
    repr: ->
        "Grid(#{@rows}, #{@cols})"

class @EntityGrid extends @Grid
    constructor: (@rows, @cols, @stage, @cell_size = 32) ->
        super(@rows, @cols)
        @shape = new createjs.Shape
        @redraw_grid()
        @stage.addChild(@shape)
    
    set_pos: (x, y) ->
        @shape.x = x
        @shape.y = y
        for row in [0...@rows]
            for col in [0...@cols]
                entity = @grid[row][col]
                if entity?
                    @update_entity_shape_pos(entity)
    
    put_entity: (entity) ->
        @grid[entity.row][entity.col] = entity
        @update_entity_shape_pos(entity)
        if entity.shape?
            @stage.addChild entity.shape
    
    update_entity_shape_pos: (entity) ->
        if entity.shape?
            shape = entity.shape
            shape.x = entity.col * @cell_size + @shape.x
            shape.y = entity.row * @cell_size + @shape.y
        
    redraw_grid: ->
        gfx = @shape.graphics
        gfx.setStrokeStyle 1
        for row in [0...@rows]
            for col in [0...@cols]
                gfx.beginStroke "grey"
                gfx.drawRect col * @cell_size, row * @cell_size, @cell_size, @cell_size
        gfx.setStrokeStyle 2
        gfx.beginStroke "black"
        gfx.drawRect 0, 0, @cols * @cell_size, @rows * @cell_size
    
    