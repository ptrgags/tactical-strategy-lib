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
    game.create_movement_grid()
    'before select movement'

fsm.add_state 'before select movement', ->
    update_controls "Please select a square above.", false
    'wait for select movement'

#Wait for the user to click one of the movement squares
fsm.add_wait 'select movement'

fsm.add_state 'move unit', ->
    game.clear_movement_grid()
    game.move_unit()
    'before select unit'
