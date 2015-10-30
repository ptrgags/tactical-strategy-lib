@init = ->
    #Create the stage (canvas)
    stage = new createjs.Stage "stage"
    
    #Create the entity grid to hold display
    #entities with display objects
    grid = new EntityGrid(10, 15, stage)
    
    #Create some Entities
    player = new Player(3, 3)
    rock_a = new Rock(4, 4)
    rock_b = new Rock(4, 6)
    move_square = new MoveSquare(2, 3)
    
    #Add all the entities
    grid.put_entity(player)
    grid.put_entity(rock_a)
    grid.put_entity(rock_b)
    grid.put_entity(move_square)
    
    #Move the grid 50 px away from each margin
    grid.set_pos(50, 50)
    
    #Don't forget it!
    stage.update()