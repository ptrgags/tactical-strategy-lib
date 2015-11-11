#TODO: Add a way to compare entity
class @Entity
    #Add ID numbers to our objects
    @id: 0
    @next_id: ->
        Entity.id++

    constructor: (@row, @col, @type, @layer) ->
        @shape = null
        @id = Entity.next_id()

    coords: ->
        [@row, @col]

#=========================================================

class @Unit extends Entity
    constructor: (@row, @col, @type, @movement) ->
        super(@row, @col, @type, 'unit')

class @Terrain extends Entity
    constructor: (@row, @col, @type, @movement_cost) ->
        super(@row, @col, @type, 'terrain')

class @Structure extends Entity
    constructor: (@row, @col, @type, @is_passable) ->
        super(@row, @col, @type, 'structure')

class @SelectionSquare extends Entity
    constructor: (@row, @col, @type) ->
        super(@row, @col, @type, 'selection')

#=========================================================

class @Player extends Unit
    constructor: (@row, @col, @movement=4, @team=0) ->
        super(@row, @col, 'player', @movement)
        if @team is 0
            @shape = shapes.player.clone()
        else
            @shape = shapes.enemy.clone()
            @shape.cache 0, 0, 32, 32


    on_click: =>
        if game.current_team is @team
            if fsm.state is 'select unit'
                fsm.do_event 'select unit', this
            else if fsm.state is 'select action'
                fsm.do_event 'deselect unit'

class @Hill extends Terrain
    constructor: (@row, @col) ->
        super(@row, @col, 'hill', 2)
        @shape = shapes.hill.clone()

class @Rock extends Structure
    constructor: (@row, @col) ->
        super(@row, @col, 'rock', false)
        @shape = shapes.rock.clone()

class @MoveSquare extends SelectionSquare
    constructor: (@row, @col) ->
        super(@row, @col, 'move square')
        @shape = shapes.move_square.clone()

    on_click: =>
        fsm.do_event 'select movement', this
