#Game starts here
@init = ->
    #Create some Entities
    players = [new Player(3, 3, 5), new Player(2, 10, 4, 2)]
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

@element = (id) ->
    document.getElementById id

@update_status = (status) ->
    element('status').innerHTML = status

@set_move_enabled = (enabled) ->
    element('move').disabled = !enabled

@set_cancel_enabled = (enabled) ->
    element('cancel').disabled = !enabled

@update_selected_unit = (unit) ->
    if unit?
        element('selected-type').innerHTML = unit.type
        element('selected-movement').innerHTML = unit.movement
        element('selected-team').innerHTML = unit.team
    else
        element('selected-type').innerHTML = '---'
        element('selected-movement').innerHTML = '---'
        element('selected-team').innerHTML = '---'

@update_under_cursor = (unit, structure, terrain) ->
    if unit?
        element('hover-unit-type').innerHTML = unit.type
        element('hover-unit-team').innerHTML = unit.team
    else
        element('hover-unit-type').innerHTML = '---'
        element('hover-unit-team').innerHTML = '---'

    if structure?
        element('hover-structure-type').innerHTML = structure.type
    else
        element('hover-structure-type').innerHTML = '---'

    if terrain?
        element('hover-terrain-type').innerHTML = terrain.type
        element('hover-terrain-cost').innerHTML = terrain.movement_cost
    else
        element('hover-terrain-type').innerHTML = '---'
        element('hover-terrain-cost').innerHTML = 1
