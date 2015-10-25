class @Grid
    constructor: (@rows, @cols, @default = null) ->
        @grid = ((@default for row in [0...@rows]) for col in [0...@cols])
    
    put: (row, col, obj) ->
        @grid[row][col] = obj
    
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