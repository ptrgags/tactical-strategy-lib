class @Game
    constructor: (rows, cols, grid_x, grid_y) ->
        @selected_unit = null
        @destination = null
        @stage = new createjs.Stage "stage"
        @fsm = fsm

        #Create the grid
        #TODO: Use a map instead
        @grid = new EntityGrid(rows, cols, @stage)
        @grid.set_pos(grid_x, grid_y)

    #TODO: Divide this by entity type
    add_entities: (entities...) ->
        for entity in entities
            @grid.put_entity entity
        @update()

    #Update the stage
    update: ->
        @stage.update()

    #Run the finite state machine
    #until the next wait
    run: ->
        @fsm.run()
        @update()
