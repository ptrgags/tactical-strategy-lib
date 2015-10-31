class @Entity
    constructor: (@row, @col, @type) ->
        @shape = null

    coords: ->
        [@row, @col]

#TODO: Add movement setting
#TODO: Rename to Unit?
class @Player extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'player')
        @shape = shapes.player.clone()
        @shape.addEventListener 'click', @on_click

    #TODO: Review these click events
    on_click: =>
        if game.fsm.state == 'wait for select unit'
            game.selected_unit = this
            game.fsm.state = 'select unit'
            game.fsm.run()

class @Rock extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'rock')
        @shape = shapes.rock.clone()

class @MoveSquare extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'move square')
        @shape = shapes.move_square.clone()
        @shape.addEventListener 'click', @on_click

    #TODO: Review these click events
    on_click: =>
        game.dest = [@row, @col]
        game.fsm.state = 'move unit'
        game.fsm.run()
