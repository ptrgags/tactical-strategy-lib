@shapes = {}
CELL_SIZE = 32

move_square = new createjs.Shape
gfx = move_square.graphics
gfx.beginFill "green"
gfx.drawRect 0, 0, CELL_SIZE, CELL_SIZE
move_square.alpha = 0.50
@shapes.move_square = move_square

rock = new createjs.Shape
gfx = rock.graphics
gfx.beginFill "black"
gfx.drawRect CELL_SIZE / 4, CELL_SIZE / 4, CELL_SIZE / 2, CELL_SIZE / 2
@shapes.rock = rock

player = new createjs.Shape
gfx = player.graphics
gfx.beginStroke "black"
gfx.beginFill "red"
gfx.drawCircle CELL_SIZE / 2, CELL_SIZE / 2, CELL_SIZE / 4
@shapes.player = player