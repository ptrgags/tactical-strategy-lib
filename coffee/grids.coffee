class @Grid
    constructor: (@rows, @cols, @default = null) ->
        @grid = ((@default for col in [0...@cols]) for row in [0...@rows])

    put: (row, col, obj) ->
        clobbered = @get row, col
        @grid[row][col] = obj
        clobbered

    get: (row, col) ->
        @grid[row][col]

    get_all: ->
        objs = []
        for row in [0...@rows]
            for col in [0...@cols]
                obj = @get row, col
                if obj?
                    objs.push obj
        objs

    remove: (row, col) ->
        removed = @get row, col
        @put row, col, @default
        removed

    #Move an object from (from_row, from_col)
    #to (to_row, to_col). Returns the clobbered
    #value or @default if nothing was there.
    move: (from_row, from_col, to_row, to_col) ->
        clobbered = @remove to_row, to_col
        obj = @remove from_row, from_col
        @put to_row, to_col, obj
        clobbered

    swap: (row_a, col_a, row_b, col_b) ->
        obj_a = @remove row_a, col_a
        obj_b = @remove row_b, col_b
        @put row_b, col_b, obj_a
        @put row_a, col_a, obj_b

    is_valid: (row, col) ->
        0 <= row < @rows and 0 <= col < @cols

    repr: ->
        "Grid(#{@rows}, #{@cols})"

#TODO: move and remove while updating the stage
#TODO: add swapping
#TODO: Entities should be stored in a container, not the stage itself
#TODO: Grid lines shouldn't go here, they should be part of map
class @EntityGrid extends @Grid
    constructor: (@rows, @cols, @stage, @cell_size = 32) ->
        super @rows, @cols
        @shape = new createjs.Shape
        @redraw_grid()
        @stage.addChild @shape

    set_offset: (x, y) ->
        @shape.x = x
        @shape.y = y
        for entity in @get_all()
            @update_entity_shape_pos entity

    put: (row, col, entity) ->
        super(row, col, entity)
        @update_entity_shape_pos entity
        @add_entity_shape entity

    put_entity: (entity) ->
        @put entity.row, entity.col, entity

    move: (from_row, from_col, to_row, to_col) ->
        entity = @get from_row, from_col
        [entity.row, entity.col] = [to_row, to_col]
        super(from_row, from_col, to_row, to_col)

    move_entity: (entity, dest_row, dest_col) ->
        @move entity.row, entity.col, dest_row, dest_col

    swap_entities: (entity_a, entity_b) ->
        @swap entity_a.row, entity_a.col, entity_b.row, entity_b.col

    remove: (row, col) ->
        entity = super(row, col)
        @remove_entity_shape entity
        entity

    remove_entity: (entity) ->
        @remove entity.row, entity.col

    update_entity_shape_pos: (entity) ->
        if entity? and entity.shape?
            shape = entity.shape
            shape.x = entity.col * @cell_size + @shape.x
            shape.y = entity.row * @cell_size + @shape.y

    remove_entity_shape: (entity) ->
        if entity? and entity.shape?
            @stage.removeChild entity.shape

    add_entity_shape: (entity) ->
        if entity? and entity.shape?
            @stage.addChild entity.shape

    #TODO: Move this to map, we only need one
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

#Container for several EntityGrids representing
#map layers
#TODO: Handle z-index when displaying each layer
class @Map
    constructor: (@rows, @cols, @stage, @cell_size = 32) ->
        #Selections
        @selections = new EntityGrid @rows, @cols, @stage, @cell_size
        #Players and enemies
        @units = new EntityGrid @rows, @cols, @stage, @cell_size
        #Structures that are mutable, unlike terrain
        @structures = new EntityGrid @rows, @cols, @stage, @cell_size
        #immutable terrain that represents the base of the map
        @terrain = new EntityGrid @rows, @cols, @stage, @cell_size

        #List of these in case we need to do the same thing to all
        #layers
        @layers = [@selections, @units, @structures, @terrain]

    set_offset: (x, y) ->
        for layer in @layers
            layer.set_offset x, y

    add_units: (units...) ->
        for unit in units
            @units.put_entity unit

    add_structures: (structures...) ->
        for structure in structures
            @structures.put_entity structure

    add_terrain: (terrain...) ->
        for terra in terrain
            @terrain.put_entity terra

    is_valid: (row, col) ->
        return @selections.is_valid row, col

    create_movement_grid: (unit) ->
        @__spawn_movement_grid unit, unit.row, unit.col, unit.movement

    #TODO: allow some structures to be moved on
    __spawn_movement_grid: (unit, row, col, movement) ->
        #If outside the grid, stop
        if not @is_valid row, col
            return

        #If we're not on the unit's square, subtract the movement
        #cost for the terrain on this tile. default is 1
        if not (unit.row is row and unit.col is col)
            terra = @terrain.get row, col
            if terra?
                movement -= terra.movement_cost
            else
                movement -= 1

        #If we're too far from the unit, stop
        if movement < 0
            return

        #Check for structures that block movement
        #TODO: Make some structures passable
        structure = @structures.get row, col
        if structure?
            return

        #make a square only if this is true.
        place_square = true

        #If there is a unit already here, we can't move here, but
        #we can move past the unit
        #TODO: Enemy units should not be passable
        other_unit = @units.get row, col
        if other_unit?
            place_square = false

        #If there's already a movement square here, we can't place
        #another one, but we can keep going
        move_square = @selections.get row, col
        if move_square?
            place_square = false

        #Place a movement square here if necesssary
        if place_square
            square = new MoveSquare row, col
            @selections.put_entity square

        #Keep spawning recursively
        @__spawn_movement_grid unit, row + 1, col, movement
        @__spawn_movement_grid unit, row - 1, col, movement
        @__spawn_movement_grid unit, row, col + 1, movement
        @__spawn_movement_grid unit, row, col - 1, movement

    clear_selection_squares: ->
        for entity in @selections.get_all()
            @selections.remove_entity entity

    move_unit: (unit, dest_row, dest_col) ->
        @units.move_entity unit, dest_row, dest_col
