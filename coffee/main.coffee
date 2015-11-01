#Game starts here
#TODO: Make Game class
#TODO: Make Map class
@init = ->
    #Create the game
    @fsm = new FSM 'setup'
    fsm.add_wait 'select unit'
    fsm.add_wait 'select action'
    fsm.add_wait 'select movement'
    fsm.add_state 'setup', states.setup
    fsm.add_state 'select unit', states.select_unit
    fsm.add_state 'create movement grid', states.create_movement_grid
    fsm.add_state 'move unit', states.move_unit

    #Create some Entities
    players = [new Player(3, 3), new Player(2,  10)]
    rocks = [new Rock(4, 4), new Rock(4, 6)]

    #Create a Game and add all the entities
    @game = new Game(10, 15, 50, 50)
    game.add_entities players...
    game.add_entities rocks...
    game.run()

#TODO: Move to Map class once created
@create_movement_grid = ->
    unit = game.selected_unit
    row = unit.row
    col = unit.col
    spawn_movement_grid unit, row, col, 5
    game.update()

#No-op command for spawn_movement_grid.
#TODO: Try to avoid no-op?
@noop = ->

#TODO: This should be a part of the Map class once created
@spawn_movement_grid = (unit, row, col, movement) ->
    #If we're too far from the unit, stop
    if movement < 0
        return

    #If outside the grid, stop
    grid = game.grid
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
    for row in [0...game.grid.rows]
        for col in [0...game.grid.cols]
            obj = game.grid.get row, col
            if obj? and obj.type == 'move square'
                square = game.grid.remove(row, col)
                if square? and square.shape?
                    game.stage.removeChild square.shape
