@shapes = {}
#TODO: Fetch cell size from the game settings?
CELL_SIZE = 32

shapes.move_square = new createjs.Shape
gfx = shapes.move_square.graphics
gfx.beginFill "green"
gfx.drawRect 0, 0, CELL_SIZE, CELL_SIZE
shapes.move_square.alpha = 0.50

shapes.rock = new createjs.Shape
gfx = shapes.rock.graphics
gfx.beginFill "black"
gfx.drawRect CELL_SIZE / 4, CELL_SIZE / 4, CELL_SIZE / 2, CELL_SIZE / 2

#TODO: Make hit area the whole square
shapes.player = new createjs.Shape
gfx = shapes.player.graphics
gfx.beginStroke "black"
gfx.beginFill "red"
gfx.drawCircle CELL_SIZE / 2, CELL_SIZE / 2, CELL_SIZE / 4
