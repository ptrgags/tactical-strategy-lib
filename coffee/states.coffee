#Create the game finite state machine
@fsm = new FSM 'select unit'

fsm.add_wait_state 'select unit', ->
    update_status "Please select a unit above."

fsm.add_event 'select unit', (unit) ->
    game.select_unit unit
    'select action'

fsm.add_wait_state 'select action', ->
    update_status "Please select an action below.",
    set_move_enabled true

fsm.add_event 'select action move', ->
    set_move_enabled false
    'create movement grid'

fsm.add_state 'create movement grid', ->
    game.create_movement_grid()
    'select movement'

fsm.add_wait_state 'select movement', ->
    update_status "Please select a square above."

fsm.add_event 'select movement', (move_square) ->
    game.set_destination move_square.coords()
    'move unit'

fsm.add_state 'move unit', ->
    game.clear_movement_grid()
    game.move_unit()
    'select unit'
