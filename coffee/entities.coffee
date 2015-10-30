class @Entity
    constructor: (@row, @col, @type) ->
        @shape = null

class @Player extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'player')
        @shape = shapes.player.clone()

class @Rock extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'rock')
        @shape = shapes.rock.clone()

class @MoveSquare extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'move square')
        @shape = shapes.move_square.clone()