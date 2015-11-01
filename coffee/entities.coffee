class @Entity
    #Add ID numbers to our objects
    @id: 0
    @next_id: ->
        Entity.id++

    constructor: (@row, @col, @type) ->
        @shape = null
        @id = Entity.next_id()

    coords: ->
        [@row, @col]

#TODO: Add movement setting
#TODO: Rename to Unit?
class @Player extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'player')
        @shape = shapes.player.clone()
        @shape.addEventListener 'click', @on_click

    on_click: =>
        if fsm.state == 'wait for select unit'
            events.select_unit this

class @Rock extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'rock')
        @shape = shapes.rock.clone()

class @MoveSquare extends Entity
    constructor: (@row, @col) ->
        super(@row, @col, 'move square')
        @shape = shapes.move_square.clone()
        @shape.addEventListener 'click', @on_click

    on_click: =>
        events.select_movement this
