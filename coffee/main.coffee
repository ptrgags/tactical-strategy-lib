#Game starts here
@init = ->
    #Create some Entities

    hills = []
    for row, i in terrain_map
        for terra, j in row
            if terra is 1
                hills.push new Hill(i, j)

    structures = []
    for row, i in structures_map
        for structure, j in row
            if structure is 1
                structures.push new Rock(i, j)

    players = []
    enemies = []
    for row, i in units_map
        for unit, j in row
            if unit is 1
                players.push new Player(i, j, 4)
            else if unit is 2
                enemies.push new Player(i, j, 4, 1)

    #Create a Game and add all the entities
    @game = new Game(10, 15, 50, 50)
    game.add_units 0, players...
    game.add_units 1, enemies... #TODO: add_team instead of add_units
    game.add_structures structures...
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

@click_end_move = ->
    fsm.do_event 'select action end move'

@click_end_turn = ->
    fsm.run 'end turn'

@element = (id) ->
    document.getElementById id

@update_team_number = (team) ->
    element('team').innerHTML = team + 1

@update_status = (status) ->
    element('status').innerHTML = status

@set_move_enabled = (enabled) ->
    element('move').disabled = !enabled

@set_cancel_enabled = (enabled) ->
    element('cancel').disabled = !enabled

@set_end_move_enabled = (enabled) ->
    element('end-move').disabled = !enabled

@set_end_turn_enabled = (enabled) ->
    element('end-turn').disabled = !enabled

@update_selected_unit = (unit) ->
    if unit?
        element('selected-type').innerHTML = unit.type
        element('selected-movement').innerHTML = unit.movement
        element('selected-team').innerHTML = unit.team + 1
    else
        element('selected-type').innerHTML = '---'
        element('selected-movement').innerHTML = '---'
        element('selected-team').innerHTML = '---'

@update_under_cursor = (unit, structure, terrain) ->
    if unit?
        element('hover-unit-type').innerHTML = unit.type
        element('hover-unit-team').innerHTML = unit.team + 1
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
