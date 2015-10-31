@states = {}

#TODO: Rename this to states.idle or something
#Prepare for the user to select the next unit
states.setup = ->
    update_controls "Please select a unit above.", false
    'wait for select unit'

#TODO: Move more functionality into this event or rename
states.select_unit = ->
    update_controls "Please select an an action below.", true
    'wait for select action'

#Create the movement grid for the selected unit
states.create_movement_grid = ->
    update_controls "Please select a square to move to", false
    create_movement_grid()
    'wait for select movement'

#Move the selected unit to the selected destination
states.move_unit = ->
    #Clear any movement squares
    clear_movement_squares()

    #Move the unit.
    #TODO: The grid should be able to do this
    [old_row, old_col] = game.selected_unit.coords()
    unit = grid.remove old_row, old_col
    if unit? and unit.shape?
        stage.removeChild unit.shape
    [unit.row, unit.col] = game.dest
    grid.put_entity unit

    #Deselect the unit
    game.selected_unit = null
    stage.update()

    #go back to setup.
    'setup'
