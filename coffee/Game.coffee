###
Class to control the game.
The point of this class is to serve
as a thin wrapper around the map and stage
to create a simple API for use in event handlers
###
class @Game
    constructor: (rows, cols, grid_x, grid_y) ->
        @selected_unit = null
        @destination = null
        @stage = new createjs.Stage "stage"
        @fsm = fsm

        #Create the map
        @map = new Map rows, cols, @stage
        @map.set_offset grid_x, grid_y

        #Set stage events
        @attach_mouse()

    add_units: (units...) ->
        @map.add_units units...
        @update()

    add_structures: (structures...) ->
        @map.add_structures structures...
        @update()

    add_terrain: (terrain...) ->
        @map.add_terrain terrain...
        @update()

    create_movement_grid: ->
        @map.create_movement_grid @selected_unit
        @update()

    clear_movement_grid: ->
        @map.clear_selection_squares()
        @update()

    select_unit: (unit) ->
        @selected_unit = unit
        update_selected_unit unit

    deselect_unit: ->
        @selected_unit = null
        update_selected_unit null

    set_destination: (coords) ->
        @destination = coords

    move_unit: ->
        @map.move_unit @selected_unit, @destination...
        @deselect_unit()
        @destination = null
        @update()

    #Update the stage
    update: ->
        @stage.update()

    attach_mouse: ->
        @stage.on 'stagemousemove', (event) =>
            @map.on_hover(event.stageX, event.stageY)
        @stage.on 'stagemouseup', (event) =>
            @map.on_click(event.stageX, event.stageY)

    #Run the finite state machine
    #until the next wait
    run: ->
        @fsm.run()
        @update()
