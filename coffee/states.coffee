#User input event functions
@events = {}

#TODO: Add before wait callback?
#TODO: Add a way to pass data to FSM or no?

#Create the game finite state machine
@fsm = new FSM 'before select unit'

#Prepare to select a unit
fsm.add_state 'before select unit', ->
    update_controls "Plese select a unit above.", false
    'wait for select unit'

#Wait for the user to click a unit
fsm.add_wait 'select unit'

fsm.add_state 'before select action', ->
    update_controls "Please select an action below.", true
    'wait for select action'

#Wait for the user to click an action button
fsm.add_wait 'select action'

fsm.add_state 'create movement grid', ->
    create_movement_grid()
    'before select movement'

fsm.add_state 'before select movement', ->
    update_controls "Please select a square above.", false
    'wait for select movement'

#Wait for the user to click one of the movement squares
fsm.add_wait 'select movement'

#TODO: Move most of this to Game or Map
fsm.add_state 'move unit', ->
    #Clear any movement squares
    clear_movement_squares()

    #Move the unit.
    #TODO: The grid should be able to do this
    [old_row, old_col] = game.selected_unit.coords()
    unit = game.grid.remove old_row, old_col
    if unit? and unit.shape?
        game.stage.removeChild unit.shape
    [unit.row, unit.col] = game.destination
    game.grid.put_entity unit

    #Deselect the unit
    game.selected_unit = null
    game.update()

    #Wait for the next unit selection
    'before select unit'
