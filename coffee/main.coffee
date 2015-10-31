#Game starts here
#TODO: Make Game class
#TODO: Make Map class
@init = ->
    #Create the game
    fsm = new FSM 'setup'
    fsm.add_wait 'select unit'
    fsm.add_wait 'select action'
    fsm.add_wait 'select movement'
    fsm.add_state 'setup', states.setup
    fsm.add_state 'select unit', states.select_unit
    fsm.add_state 'create movement grid', states.create_movement_grid
    fsm.add_state 'move unit', states.move_unit
    @game =
        fsm: fsm
        selected_unit: null
        dest: null

    #Create the stage (canvas)
    @stage = new createjs.Stage "stage"

    #Create the entity grid to hold display
    #entities with display objects
    @grid = new EntityGrid(10, 15, stage)

    #Create some Entities
    player = new Player(3, 3)
    player_b = new Player(2, 10)
    rock_a = new Rock(4, 4)
    rock_b = new Rock(4, 6)
    move_square = new MoveSquare(2, 3)

    #Add all the entities
    grid.put_entity(player)
    grid.put_entity(player_b)
    grid.put_entity(rock_a)
    grid.put_entity(rock_b)

    #Move the grid 50 px away from each margin
    grid.set_pos(50, 50)

    #Don't forget it!
    stage.update()

    #Run the state machine up until the first wait.
    #Events will take it from here
    fsm.run()

#TODO: Move to Map class once created
@create_movement_grid = ->
    unit = game.selected_unit
    row = unit.row
    col = unit.col
    spawn_movement_grid unit, row, col, 5
    stage.update()

#No-op command for spawn_movement_grid.
#TODO: Try to avoid no-op?
@noop = ->

#This should be a part of the Map class once created
@spawn_movement_grid = (unit, row, col, movement) ->
    #If we're too far from the unit, stop
    if movement < 0
        return

    #If outside the grid, stop
    if not grid.is_valid row, col
        return

    obj = grid.get row, col
    #Test if there is an object or not
    if obj?
        #Can't go through obstacles
        if obj.type in ['rock']
            return
        #If we encounter a player or move square,
        #We don't place a move square but keep going
        if obj.type in ['player', 'move square']
            noop()
    else
        #Empty square, we can place a move square!
        move_square = new MoveSquare(row, col)
        grid.put_entity move_square

    spawn_movement_grid unit, row + 1, col, movement - 1
    spawn_movement_grid unit, row - 1, col, movement - 1
    spawn_movement_grid unit, row, col + 1, movement - 1
    spawn_movement_grid unit, row, col - 1, movement - 1

#TODO: Move controls to canvas

#Move button callback
@click_move = ->
    game.fsm.state = "create movement grid"
    game.fsm.run()

@update_controls = (status, move_enabled) ->
    document.getElementById('status').innerHTML = status
    document.getElementById('move').disabled = !move_enabled

#Clear all movement squares from the grid
#TODO: Should be part of the Map class once made
@clear_movement_squares = ->
    for row in [0...grid.rows]
        for col in [0...grid.cols]
            obj = grid.get row, col
            if obj? and obj.type == 'move square'
                square = grid.remove(row, col)
                if square? and square.shape?
                    stage.removeChild square.shape
