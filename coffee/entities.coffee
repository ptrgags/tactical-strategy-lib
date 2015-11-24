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
        @shape = shapes.player.clone()
        disabled_matrix = new createjs.ColorMatrix().adjustSaturation(-100)
        @disabled_filter = new createjs.ColorMatrixFilter disabled_matrix
        blue_matrix = new createjs.ColorMatrix().adjustHue(-120)
        @blue_filter = new createjs.ColorMatrixFilter blue_matrix

        if @team is 0
            @shape.filters = []
        else
            @shape.filters = [@blue_filter]
        @shape.cache 0, 0, CELL_SIZE, CELL_SIZE

        @enabled = true

    disable: ->
        @enabled = false
        @shape.filters = [@disabled_filter]
        @shape.updateCache 0, 0, CELL_SIZE, CELL_SIZE

    enable: ->
        @enabled = true
        if @team is 0
            @shape.filters = []
        else
            @shape.filters = [@blue_filter]
        @shape.updateCache 0, 0, CELL_SIZE, CELL_SIZE

    on_click: =>
        if @enabled and game.current_team is @team
            if fsm.state is 'select unit'
                fsm.do_event 'select unit', this
            else if fsm.state is 'select action'
                if @id is game.selected_unit.id
                    fsm.do_event 'deselect unit'
                else
                    fsm.do_event 'select unit', this

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
