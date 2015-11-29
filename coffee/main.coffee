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

@update_team_number = (team) ->
    $('#team').html team + 1

@update_status = (status) ->
    $('#status').html status

@set_move_enabled = (enabled) ->
    $('#move').prop 'disabled', !enabled

@set_cancel_enabled = (enabled) ->
    $('#cancel').prop 'disabled', !enabled

@set_end_move_enabled = (enabled) ->
    $('#end-move').prop 'disabled', !enabled

@set_end_turn_enabled = (enabled) ->
    $('#end-turn').prop 'disabled', !enabled

@update_selected_unit = (unit) ->
    if unit?
        $('#selected-type').html unit.type
        $('#selected-movement').html unit.movement
        $('#selected-team').html unit.team + 1
    else
        $('#selected-type').html '---'
        $('#selected-movement').html '---'
        $('#selected-team').html '---'

@update_under_cursor = (unit, structure, terrain) ->
    if unit?
        $('#hover-unit-type').html unit.type
        $('#hover-unit-team').html unit.team + 1
    else
        $('#hover-unit-type').html '---'
        $('#hover-unit-team').html '---'

    if structure?
        $('#hover-structure-type').html structure.type
    else
        $('#hover-structure-type').html '---'

    if terrain?
        $('#hover-terrain-type').html terrain.type
        $('#hover-terrain-cost').html terrain.movement_cost
    else
        $('#hover-terrain-type').html '---'
        $('#hover-terrain-cost').html 1
