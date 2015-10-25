@init = ->
    stage = new createjs.Stage "stage"
    
    grid = new Grid 10, 15
    grid_gui = new GridGui(grid)
    
    stage.addChild(grid_gui.shape)
    grid_gui.set_pos(50, 50)
    [x, y] = grid_gui.get_pos()
        
    player =
        x: 3
        y: 3
        type: "player"
        
    grid.put 3, 3, player
    
    rock_a = 
        x: 4
        y: 4
        type: "rock"

    rock_b =
        x: 6
        y: 4
        type: "rock"
        
    grid.put 4, 4, rock_a
    grid.put 6, 4, rock_b
    
    player_gui = new createjs.Shape
    gfx = player_gui.graphics
    gfx.beginStroke "black"
    gfx.beginFill "red"
    gfx.drawCircle 16, 16, 10
    player_gui.x = player.x * grid_gui.cell_size + x
    player_gui.y = player.x * grid_gui.cell_size + y
    stage.addChild player_gui
    
    rock_gui_a = new createjs.Shape
    gfx = rock_gui_a.graphics
    gfx.beginFill "black"
    gfx.drawRect  8, 8, 16, 16
    rock_gui_a.x = rock_a.x * grid_gui.cell_size + x
    rock_gui_a.y = rock_a.y * grid_gui.cell_size + y
    stage.addChild rock_gui_a
    
    rock_gui_b = rock_gui_a.clone()
    rock_gui_b.x = rock_b.x * grid_gui.cell_size + x
    rock_gui_b.y = rock_b.y * grid_gui.cell_size + y
    stage.addChild rock_gui_b
    
    move_square = 
        x: 3
        y: 2
        type: "move square"
    
    move_square_gui = new createjs.Shape
    gfx = move_square_gui.graphics
    gfx.beginFill "green"
    gfx.drawRect 0, 0, grid_gui.cell_size, grid_gui.cell_size
    move_square_gui.alpha = 0.50
    move_square_gui.x = move_square.x * grid_gui.cell_size + x
    move_square_gui.y = move_square.y * grid_gui.cell_size + x
    stage.addChild move_square_gui
    
    stage.update()