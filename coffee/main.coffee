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
    
    player_gui = @shapes.player.clone()
    player_gui.x = player.x * grid_gui.cell_size + x
    player_gui.y = player.x * grid_gui.cell_size + y
    stage.addChild player_gui
    
    rock_gui_a = @shapes.rock.clone()
    rock_gui_a.x = rock_a.x * grid_gui.cell_size + x
    rock_gui_a.y = rock_a.y * grid_gui.cell_size + y
    stage.addChild rock_gui_a
    
    rock_gui_b = @shapes.rock.clone()
    rock_gui_b.x = rock_b.x * grid_gui.cell_size + x
    rock_gui_b.y = rock_b.y * grid_gui.cell_size + y
    stage.addChild rock_gui_b
    
    move_square = 
        x: 3
        y: 2
        type: "move square"
    
    move_square_gui = @shapes.move_square
    move_square_gui.x = move_square.x * grid_gui.cell_size + x
    move_square_gui.y = move_square.y * grid_gui.cell_size + x
    stage.addChild move_square_gui
    
    stage.update()