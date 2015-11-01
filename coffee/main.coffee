#Game starts here
@init = ->
    #Create some Entities
    players = [new Player(3, 3), new Player(2,  10)]
    rocks = [new Rock(4, 4), new Rock(4, 6)]

    #Create a Game and add all the entities
    @game = new Game(10, 15, 50, 50)
    game.add_units players...
    game.add_structures rocks...
    game.run()

#TODO: Move controls to canvas
@click_move = ->
    events.select_action_move()

@update_status = (status) ->
    document.getElementById('status').innerHTML = status

@set_move_enabled = (enabled) ->
    document.getElementById('move').disabled = !enabled
