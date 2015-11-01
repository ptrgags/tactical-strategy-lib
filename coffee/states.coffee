#User input event functions
@events = {}

#TODO: Add before wait callback?
#TODO: Add a way to pass data to FSM or no?

#Create the game finite state machine
@fsm = new FSM 'before select unit'

#Prepare to select a unit
fsm.add_state 'before select unit', ->
    update_status "Please select a unit above."
    'wait for select unit'

#Wait for the user to click a unit
fsm.add_wait 'select unit'

events.select_unit = (unit) ->
    game.selected_unit = unit   #TODO: Maybe wrap up in Game?
    fsm.run_from 'before select action'

fsm.add_state 'before select action', ->
    update_status "Please select an action below.",
    set_move_enabled true
    'wait for select action'

#Wait for the user to click an action button
fsm.add_wait 'select action'

#Called when the Move button is pressed
events.select_action_move = ->
    set_move_enabled false
    fsm.run_from "create movement grid"

fsm.add_state 'create movement grid', ->
    game.create_movement_grid()
    'before select movement'

fsm.add_state 'before select movement', ->
    update_status "Please select a square above."
    'wait for select movement'

#Wait for the user to click one of the movement squares
fsm.add_wait 'select movement'

#Select a movement square
events.select_movement = (move_square) ->
    game.destination = move_square.coords()
    fsm.run_from 'move unit'

fsm.add_state 'move unit', ->
    game.clear_movement_grid()
    game.move_unit()
    'before select unit'
