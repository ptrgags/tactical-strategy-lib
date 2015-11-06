#Game starts here
@init = ->
    #Create some Entities
    players = [new Player(3, 3, 5), new Player(2,  10)]
    rocks = [new Rock(4, 4), new Rock(4, 6)]
    hills = (new Hill(2, i) for i in [2..6])

    #Create a Game and add all the entities
    @game = new Game(10, 15, 50, 50)
    game.add_units players...
    game.add_structures rocks...
    game.add_terrain hills...
    game.run()

#TODO: Move controls to canvas
@click_move = ->
    fsm.do_event 'select action move'

@click_cancel = ->
    if fsm.state is 'select action'
        fsm.do_event 'deselect unit'
    else if fsm.state is 'select movement'
        fsm.do_event 'deselect action move'

@update_status = (status) ->
    document.getElementById('status').innerHTML = status

@set_move_enabled = (enabled) ->
    document.getElementById('move').disabled = !enabled

@set_cancel_enabled = (enabled) ->
    document.getElementById('cancel').disabled = !enabled

@update_selected_unit = (unit) ->
    if unit?
        document.getElementById('selected-type').innerHTML = unit.type
        document.getElementById('selected-movement').innerHTML = unit.movement
    else
        document.getElementById('selected-type').innerHTML = '---'
        document.getElementById('selected-movement').innerHTML = '---'
