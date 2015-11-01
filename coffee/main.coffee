#Game starts here
#TODO: Make Game class
#TODO: Make Map class
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
#Move button callback
@click_move = ->
    game.fsm.state = "create movement grid"
    game.fsm.run()

#Split into separate functions
@update_controls = (status, move_enabled) ->
    document.getElementById('status').innerHTML = status
    document.getElementById('move').disabled = !move_enabled
